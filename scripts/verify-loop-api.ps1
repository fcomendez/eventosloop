# Verificacion API LOOP (no modifica datos). Uso interno / CI local.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

$Base = "http://127.0.0.1:54321"
$Anon = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"

$passed = 0
$failed = 0
$results = [System.Collections.Generic.List[string]]::new()

function Assert-Ok($name, $cond, $detail = "") {
  if ($cond) {
    $script:passed++
    $script:results.Add("OK   $name")
  } else {
    $script:failed++
    $script:results.Add("FAIL $name $detail")
  }
}

function Invoke-Rest($Method, $Path, $Token = $null, $Body = $null) {
  $headers = @{ apikey = $Anon }
  if ($Token) { $headers.Authorization = "Bearer $Token" }
  $uri = "$Base$Path"
  if ($Body) {
    return Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers -ContentType "application/json" -Body ($Body | ConvertTo-Json -Compress)
  }
  return Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers
}

function Login($email, $password) {
  $body = @{ email = $email; password = $password }
  $r = Invoke-RestMethod -Method Post -Uri "$Base/auth/v1/token?grant_type=password" -Headers @{ apikey = $Anon } -ContentType "application/json" -Body ($body | ConvertTo-Json -Compress)
  return $r.access_token
}

function Get-Rows($path, $token) {
  return @(Invoke-Rest Get $path $token)
}

Write-Host "=== Verificacion LOOP API ==="

# Docker
$containers = @(docker compose ps --services 2>$null)
Assert-Ok "docker compose servicios definidos" ($containers.Count -ge 8) "count=$($containers.Count)"

# Auth
try {
  $adminToken = Login "admin@loop.cl" "LoopAdmin1"
  Assert-Ok "login admin" ($null -ne $adminToken -and $adminToken.Length -gt 20)
} catch {
  Assert-Ok "login admin" $false $_.Exception.Message
  $adminToken = $null
}

try {
  $userToken = Login "user@loop.cl" "LoopUser1"
  Assert-Ok "login user@loop.cl" ($null -ne $userToken)
} catch {
  Assert-Ok "login user@loop.cl" $false $_.Exception.Message
  $userToken = $null
}

try {
  $demoToken = Login "valentina.morales@loop.cl" "LoopDemo1"
  Assert-Ok "login demo valentina" ($null -ne $demoToken)
} catch {
  Assert-Ok "login demo valentina" $false $_.Exception.Message
}

try {
  Login "admin@loop.cl" "wrong" | Out-Null
  Assert-Ok "login invalido rechazado" $false "acepto credenciales malas"
} catch {
  Assert-Ok "login invalido rechazado" $true
}

if (-not $adminToken) {
  Write-Host "Sin token admin; abortando pruebas REST."
  $results | ForEach-Object { Write-Host $_ }
  exit 1
}

# IDs secuenciales
$users = Get-Rows "/rest/v1/usuario?select=id_usuario,email,estado_cuenta&order=id_usuario.asc&limit=5" $adminToken
Assert-Ok "usuarios existen" ($users.Count -ge 5)
Assert-Ok "usuario id empieza en 1" ($users[0].id_usuario -eq 1)
Assert-Ok "admin id=1" ($users[0].email -eq "admin@loop.cl")

$allUsers = Get-Rows "/rest/v1/usuario?select=id_usuario&order=id_usuario.desc&limit=1" $adminToken
Assert-Ok "50 usuarios demo" ($allUsers[0].id_usuario -eq 50)

# Perfiles 1-15 (ruta openUserProfile)
for ($id = 1; $id -le 15; $id++) {
  $row = @(Get-Rows "/rest/v1/usuario?select=id_usuario,nombres,apellidos,username&id_usuario=eq.$id" $adminToken)
  Assert-Ok "perfil usuario $id" ($row.Count -eq 1 -and $row[0].id_usuario -eq $id)
}

# Feed
$posts = Get-Rows "/rest/v1/publicaciones?select=id_post,titulo,usuario_id_usuario,comunidades_id_comunidad&order=id_post.desc&limit=10" $adminToken
Assert-Ok "feed publicaciones" ($posts.Count -ge 6)
Assert-Ok "post id max ~100" ($posts[0].id_post -ge 50)

for ($i = 0; $i -lt [Math]::Min(5, $posts.Count); $i++) {
  $p = $posts[$i]
  Assert-Ok "post $($p.id_post) tiene autor" ($null -ne $p.usuario_id_usuario)
}

# Post detalle (openPostDetail)
for ($postId = 1; $postId -le 10; $postId++) {
  $row = @(Get-Rows "/rest/v1/publicaciones?select=id_post,usuario_id_usuario&id_post=eq.$postId" $adminToken)
  Assert-Ok "post detalle id $postId" ($row.Count -eq 1)
}

# Comunidades 1-15 (openCommunityDetail)
$comms = Get-Rows "/rest/v1/comunidades?select=id_comunidad,nombre,estado&order=id_comunidad.asc&limit=5" $adminToken
Assert-Ok "comunidades existen" ($comms.Count -ge 5)
Assert-Ok "comunidad id empieza en 1" ($comms[0].id_comunidad -eq 1)

for ($cid = 1; $cid -le 15; $cid++) {
  $row = @(Get-Rows "/rest/v1/comunidades?select=id_comunidad,nombre&id_comunidad=eq.$cid" $adminToken)
  Assert-Ok "comunidad detalle $cid" ($row.Count -eq 1)
}

# Miembros comunidad
for ($cid = 1; $cid -le 5; $cid++) {
  $mem = Get-Rows "/rest/v1/miembro_comunidad?select=id_comunidad,usuario_id_usuario,rol&id_comunidad=eq.$cid&limit=3" $adminToken
  Assert-Ok "miembros comunidad $cid" ($mem.Count -ge 1)
}

# Eventos 1-15 (openEventDetail)
$evs = Get-Rows "/rest/v1/evento?select=id_evento,titulo,estado&order=id_evento.asc&limit=5" $adminToken
Assert-Ok "eventos existen" ($evs.Count -ge 5)
Assert-Ok "evento id empieza en 1" ($evs[0].id_evento -eq 1)

for ($eid = 1; $eid -le 15; $eid++) {
  $row = @(Get-Rows "/rest/v1/evento?select=id_evento,titulo,estado&id_evento=eq.$eid" $adminToken)
  Assert-Ok "evento detalle $eid" ($row.Count -eq 1)
}

# Busqueda explorar (simula ExploreSearchService)
$searchP = Get-Rows "/rest/v1/usuario?select=id_usuario,nombres&estado_cuenta=eq.ACTIVO&or=(nombres.ilike.*valentina*,apellidos.ilike.*valentina*)&limit=5" $adminToken
Assert-Ok "buscar persona valentina" ($searchP.Count -ge 1)

$searchC = Get-Rows "/rest/v1/comunidades?select=id_comunidad,nombre&estado=eq.ACTIVA&nombre=ilike.*Santiago*&limit=5" $adminToken
Assert-Ok "buscar comunidad Santiago" ($searchC.Count -ge 1)

$searchE = Get-Rows "/rest/v1/evento?select=id_evento,titulo&estado=eq.ACTIVO&titulo=ilike.*yoga*&limit=5" $adminToken
Assert-Ok "buscar evento yoga" ($searchE.Count -ge 1)

# Catalogo onboarding
$intereses = Get-Rows "/rest/v1/intereses?select=id_interes,nombre&limit=5" $adminToken
Assert-Ok "catalogo intereses" ($intereses.Count -ge 5)

$regiones = Get-Rows "/rest/v1/region?select=id_region,nombre&limit=3" $adminToken
Assert-Ok "catalogo regiones" ($regiones.Count -ge 1)

# Admin datos
$pendingComm = Get-Rows "/rest/v1/comunidades?select=id_comunidad&estado=eq.PENDIENTE" $adminToken
Assert-Ok "comunidad pendiente demo" ($pendingComm.Count -ge 1)

$partCount = Get-Rows "/rest/v1/participantes_evento?select=id_participacion&limit=1" $adminToken
Assert-Ok "participaciones evento" ($partCount.Count -ge 1)

$likes = Get-Rows "/rest/v1/reacciones_post?select=publicaciones_id_post&limit=5" $adminToken
Assert-Ok "reacciones feed" ($likes.Count -ge 1)

$comments = Get-Rows "/rest/v1/comentario?select=id_comentario&limit=3" $adminToken
Assert-Ok "comentarios posts" ($comments.Count -ge 1)

$follows = Get-Rows "/rest/v1/seguidores?select=id_usuario_seguidor&limit=3" $adminToken
Assert-Ok "seguidores" ($follows.Count -ge 1)

# Perfil propio via auth
$me = @(Get-Rows "/rest/v1/usuario?select=id_usuario,email&auth_user_id=eq.11111111-1111-1111-1111-111111111111" $adminToken)
Assert-Ok "perfil propio admin auth" ($me.Count -eq 1 -and $me[0].id_usuario -eq 1)

# Storage health via rest meta (buckets via sql indirect - skip if no service role)
try {
  $health = Invoke-WebRequest -Uri "$Base/rest/v1/" -Headers @{ apikey = $Anon } -UseBasicParsing
  Assert-Ok "REST gateway responde" ($health.StatusCode -eq 200)
} catch {
  Assert-Ok "REST gateway responde" $false
}

Write-Host ""
Write-Host "Pasaron: $passed | Fallaron: $failed | Total: $($passed + $failed)"
$results | ForEach-Object { Write-Host $_ }
if ($failed -gt 0) { exit 1 }
exit 0

# Genera loop_schema.sql, loop_seed_catalogo.sql y loop_seed_demo.sql
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

$src = Get-Content "docs\sql\archive\migraciones\schema_completo.sql" -Raw

# Extraer bloques de catalogo
if ($src -notmatch '(?s)(insert into public\.region \(nombre\).*?on conflict \(nombre\) do nothing;)') {
  throw "No se encontro insert de region"
}
$regionInsert = $Matches[1]

if ($src -notmatch '(?s)(insert into public\.comuna \(nombre, region_id_region\).*?on conflict \(nombre, region_id_region\) do nothing;)') {
  throw "No se encontro insert de comuna"
}
$comunaInsert = $Matches[1]

if ($src -notmatch '(?s)(-- Semilla inicial basada en listado inicial de intereses.*?activo = true;)') {
  throw "No se encontro insert de intereses"
}
$interesesInsert = $Matches[1]

# Quitar inserts del esquema base
$schemaBase = $src
$schemaBase = $schemaBase -replace '(?s)insert into public\.region \(nombre\).*?on conflict \(nombre\) do nothing;\r?\n', ''
$schemaBase = $schemaBase -replace '(?s)insert into public\.comuna \(nombre, region_id_region\).*?on conflict \(nombre, region_id_region\) do nothing;\r?\n', ''
$schemaBase = $schemaBase -replace '(?s)-- Semilla inicial basada en listado inicial de intereses.*?activo = true;\r?\n', ''

$fase2 = Get-Content "docs\sql\archive\migraciones\migracion_comunidades_fase2.sql" -Raw
$reporteEvento = Get-Content "docs\sql\archive\migraciones\reporte_evento.sql" -Raw
$anonRead = Get-Content "docs\sql\archive\migraciones\region_comuna_public_read.sql" -Raw

$loopSchema = @"
-- LOOP — Esquema completo (tablas, RLS, RPCs)
-- Sin datos de catalogo ni demo. Ejecutar con scripts/apply-schema.ps1
-- Idempotente: se puede re-ejecutar en desarrollo.

$schemaBase

-- ---------------------------------------------------------------------------
-- Comunidades fase 2: estado, intereses puente, RLS avanzada, RPCs
-- ---------------------------------------------------------------------------
$fase2

-- ---------------------------------------------------------------------------
-- Reportes de eventos
-- ---------------------------------------------------------------------------
$reporteEvento

-- ---------------------------------------------------------------------------
-- Lectura anonima region/comuna (formulario de registro)
-- ---------------------------------------------------------------------------
$anonRead
"@

$catalogo = @"
-- LOOP — Catalogo de referencia (regiones, comunas, intereses)
-- Ejecutar DESPUES de loop_schema.sql via scripts/seed-catalogo.ps1
-- Re-ejecutable (on conflict do nothing / do update).

$regionInsert

$comunaInsert

$interesesInsert
"@

$usuarios = Get-Content "docs\sql\archive\seeds\seed_usuarios_demo.sql" -Raw
$comunidades = Get-Content "docs\sql\archive\seeds\seed_comunidades_demo.sql" -Raw
$eventosPosts = Get-Content "docs\sql\archive\seeds\seed_eventos_publicaciones_demo.sql" -Raw

$usuarios = $usuarios -replace 'apply-schema\.ps1', 'seed-catalogo.ps1'
$usuarios = $usuarios -replace 'No hay comunas\. Ejecuta seed-catalogo\.ps1 primero\.', 'No hay comunas. Ejecuta scripts/seed-catalogo.ps1 primero.'
$comunidades = $comunidades -replace 'seed_usuarios_demo\.sql y migracion_comunidades_fase2\.sql', 'loop_seed_demo.sql (bloque usuarios)'
$comunidades = $comunidades -replace 'Ejecuta seed_usuarios_demo\.sql primero\.', 'Ejecuta loop_seed_demo.sql (usuarios) primero.'
$eventosPosts = $eventosPosts -replace 'seed_comunidades_demo\.sql', 'loop_seed_demo.sql (bloque comunidades)'
$eventosPosts = $eventosPosts -replace 'No hay comunas\. Ejecuta apply-schema\.ps1 primero\.', 'No hay comunas. Ejecuta scripts/seed-catalogo.ps1 primero.'

$loopDemo = @"
-- LOOP — Datos demo (usuarios Auth, comunidades, eventos, publicaciones)
-- Ejecutar DESPUES de loop_seed_catalogo.sql via scripts/seed-demo.ps1
-- Re-ejecutable.

-- === Usuarios ===
$usuarios

-- === Comunidades ===
$comunidades

-- === Eventos y publicaciones ===
$eventosPosts
"@

Set-Content -Path "docs\sql\loop_schema.sql" -Value $loopSchema -Encoding UTF8
Set-Content -Path "docs\sql\loop_seed_catalogo.sql" -Value $catalogo -Encoding UTF8
Set-Content -Path "docs\sql\loop_seed_demo.sql" -Value $loopDemo -Encoding UTF8
Copy-Item "docs\sql\loop_schema.sql" "docker\db\init\migrations\100-loop-schema.sql" -Force

Write-Host "Generados: loop_schema.sql, loop_seed_catalogo.sql, loop_seed_demo.sql"
Write-Host "Sincronizado: docker/db/init/migrations/100-loop-schema.sql"

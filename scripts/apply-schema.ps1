# Aplica el esquema LOOP despues de: docker compose up -d
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

Write-Host "Esperando Postgres..."
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  docker compose exec -T db pg_isready -U postgres -h localhost 2>$null
  if ($LASTEXITCODE -eq 0) { $ready = $true; break }
  Start-Sleep -Seconds 2
}
if (-not $ready) {
  Write-Error "Postgres no respondio. Ejecuta: docker compose up -d"
}

Write-Host "Aplicando docs/sql/schema_completo.sql (puede tardar 1-2 min)..."
Get-Content "docs\sql\schema_completo.sql" -Raw | docker compose exec -T db psql -U postgres -d postgres -v ON_ERROR_STOP=1
Write-Host "Esquema aplicado."

# Catalogo LOOP: regiones, comunas, intereses
# Ejecutar despues de apply-schema.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

Write-Host "Insertando catalogo (regiones, comunas, intereses)..."
Get-Content "docs\sql\loop_seed_catalogo.sql" -Raw | docker compose exec -T db psql -U postgres -d postgres -v ON_ERROR_STOP=1
Write-Host "Catalogo aplicado."

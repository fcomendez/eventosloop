# Datos demo LOOP (usuarios, comunidades, eventos, posts)
# Ejecutar despues de seed-catalogo.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

Write-Host "Insertando datos demo..."
Get-Content "docs\sql\loop_seed_demo.sql" -Raw | docker compose exec -T db psql -U postgres -d postgres -v ON_ERROR_STOP=1

Write-Host "Listo. 50 usuarios demo @loop.cl"
Write-Host "  Admin: admin@loop.cl / LoopAdmin1"
Write-Host "  user@loop.cl: LoopUser1 | resto @loop.cl: LoopDemo1"

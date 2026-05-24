# Datos demo LOOP (usuarios, comunidades, eventos, posts)
# Ejecutar despues de seed-catalogo.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

Write-Host "Insertando datos demo..."
Get-Content "docs\sql\loop_seed_demo.sql" -Raw | docker compose exec -T db psql -U postgres -d postgres -v ON_ERROR_STOP=1

Write-Host ""
Write-Host "Listo. Credenciales:"
Write-Host "  Admin:     admin@loop.cl              / LoopAdmin1"
Write-Host "  User:      user@loop.cl               / LoopUser1"
Write-Host "  Valentina: valentina.morales@loop.cl  / LoopDemo1"
Write-Host "  Diego:     diego.henriquez@loop.cl    / LoopDemo1"
Write-Host "  Camila:    camila.rosas@loop.cl       / LoopDemo1"
Write-Host "  Matias:    matias.vega@loop.cl        / LoopDemo1"
Write-Host "  Sofia:     sofia.torres@loop.cl       / LoopDemo1"

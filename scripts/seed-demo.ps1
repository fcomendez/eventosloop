# Usuarios demo: admin + user normal (ejecutar despues de apply-schema.ps1)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

Write-Host "Insertando usuarios demo..."
Get-Content "docs\sql\seed_usuarios_demo.sql" -Raw | docker compose exec -T db psql -U postgres -d postgres -v ON_ERROR_STOP=1

Write-Host ""
Write-Host "Listo. Credenciales:"
Write-Host "  Admin: admin@loop.cl / LoopAdmin1"
Write-Host "  User:  user@loop.cl  / LoopUser1"

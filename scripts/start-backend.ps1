# Levantar backend LOOP (Windows)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Creado .env desde .env.example"
}

Write-Host "Iniciando contenedores Docker..."
docker compose up -d

Write-Host ""
Write-Host "API Supabase local: http://127.0.0.1:54321"
Write-Host "Studio:             http://127.0.0.1:54323"
Write-Host "Postgres:           localhost:54322"
Write-Host ""
Write-Host "Ver estado: docker compose ps"

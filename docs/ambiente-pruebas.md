# Ambiente de pruebas — LOOP

Documento para la rúbrica: configuración reproducible, backup y verificación.

## Arquitectura

```
Flutter (Android/Web)
        │
        ▼
   Kong :54321  ← API pública
    ├── Auth (GoTrue)   → login / registro / JWT
    ├── REST (PostgREST) → tablas public.*
    └── Meta → Studio :54323
        │
        ▼
   PostgreSQL :54322
```

## Ambiente de pruebas vs producción

| Aspecto | Pruebas (local) | Producción (referencia) |
|---|---|---|
| Backend | `docker compose up -d` | Mismo stack en servidor/VPS |
| API URL | `http://127.0.0.1:54321` | `https://tu-dominio.com` |
| BD | Postgres en `loop-db` | Postgres gestionado |
| Auth | GoTrue local | GoTrue en servidor |
| Confirmación email | Auto (`ENABLE_EMAIL_AUTOCONFIRM=true`) | SMTP real |

En desarrollo usamos **un solo entorno Docker** en la máquina del desarrollador. Para producción se despliega el mismo `docker-compose.yml` con variables y secretos distintos.

## Instalación (reproducible)

1. Instalar Docker Desktop y Flutter.
2. Clonar repositorio.
3. `copy .env.example .env`
4. `docker compose up -d`
5. `flutter pub get && flutter run` (con `--dart-define` si usas emulador Android).

El esquema de BD se carga automáticamente la **primera vez** desde `docker/db/init/migrations/100-loop-schema.sql` (copia de `docs/sql/schema_completo.sql`).

## Contenedores incluidos

Ver tabla en `README.md`. Todos están definidos en `docker-compose.yml` en la raíz del proyecto.

## Backup de base de datos (prod → prueba)

### Exportar (origen)

Con Docker levantado:

```powershell
docker compose exec -T db pg_dump -U postgres -d postgres --schema=public > backup-loop.sql
```

Desde Supabase cloud (si existiera proyecto remoto): Dashboard → Database → Backups / SQL export.

### Restaurar (destino de prueba)

```powershell
docker compose down -v
docker compose up -d
# Esperar que loop-db esté healthy
Get-Content backup-loop.sql | docker compose exec -T db psql -U postgres -d postgres
```

## Verificación del ambiente

Checklist operativo:

- [ ] `docker compose ps` → todos `running` / `healthy`
- [ ] http://127.0.0.1:54323 → abre Studio
- [ ] Registro de usuario en la app → fila en Auth + tabla `usuario`
- [ ] Login email/contraseña → navega al feed o onboarding
- [ ] `flutter analyze` sin errores

## Usuario de demostración

Tras levantar Docker, registrar desde la app o Studio:

- Email: `demo@loop.cl`
- Contraseña: `Demo1234` (ejemplo; crear el que usen en presentación)

## Solución de problemas

| Problema | Solución |
|---|---|
| `connection refused` en app | Docker no está arriba o URL incorrecta (emulador → `10.0.2.2`) |
| Tablas vacías / sin regiones | `docker compose down -v` y `up -d` de nuevo |
| Puerto 54321 ocupado | Cambiar mapeo en `docker-compose.yml` o cerrar proceso conflictivo |
| Auth falla tras cambiar JWT | Regenerar `.env` con claves coherentes y recrear volumen |

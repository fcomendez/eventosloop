# LOOP (`eventosloop`)

App Flutter + backend local con Docker (Supabase self-hosted).

## Requisitos

Docker Desktop · Flutter SDK · Android Studio

## Instalación

```powershell
git clone <URL_DEL_REPO>
cd eventosloop
copy .env.example .env
docker compose up -d
```

Comprobar: `docker compose ps` → 6 contenedores `loop-*` en **Up**.

**Solo la primera vez** (o tras `docker compose down -v`):

```powershell
powershell -ExecutionPolicy Bypass -File scripts\apply-schema.ps1
powershell -ExecutionPolicy Bypass -File scripts\seed-demo.ps1
```

| URL | Uso |
|---|---|
| http://127.0.0.1:54321 | API (Supabase) |
| http://127.0.0.1:54323 | Studio (ver BD) |

## Credenciales demo

Creadas por `scripts\seed-demo.ps1` (solo desarrollo local):

| Rol | Email | Contraseña |
|---|---|---|
| **Admin** | `admin@loop.cl` | `LoopAdmin1` |
| **Usuario** | `user@loop.cl` | `LoopUser1` |

**Anon key** (Supabase local):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

## App Flutter

```powershell
flutter pub get
```

**Android Studio → Run → Edit Configurations → Additional run args**

Emulador Android:

```
--dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

Chrome / Web:

```
--dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

Celular físico (misma WiFi; reemplaza la IP):

```
--dart-define=SUPABASE_URL=http://192.168.1.50:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

IP de tu PC: `ipconfig` → IPv4.

Luego: Docker en **Running** → Android Studio → **Run** ▶ → login con `admin@loop.cl` o `user@loop.cl`.

## Contenedores (`docker-compose.yml`)

`loop-db` · `loop-auth` · `loop-rest` · `loop-kong` · `loop-meta` · `loop-studio`

## Comandos útiles

```powershell
docker compose down
docker compose down -v && docker compose up -d
flutter build apk --debug
```

Más detalle: `docs/ambiente-pruebas.md` · `docs/supabase-integracion.md`

# LOOP (`eventosloop`)

App Flutter para descubrir eventos y comunidades, con backend local Supabase self-hosted en Docker.

---

## Requisitos

| Herramienta | Uso |
|-------------|-----|
| **Docker Desktop** | Backend (Postgres, Auth, API, Studio) |
| **Flutter SDK** | App m├│vil / web |
| **Android Studio** | Emulador Android (o Chrome para web) |
| **PowerShell** | Scripts de base de datos (Windows) |

---

## Gu├¡a r├ípida: clonar y probar

Sigue estos pasos en orden la **primera vez** que clones el repo (o despu├®s de `docker compose down -v`).

### 1. Clonar y configurar entorno

```powershell
git clone <URL_DEL_REPO>
cd eventosloop
copy .env.example .env
```

### 2. Levantar Docker

```powershell
docker compose up -d
```

Comprobar que todo est├® arriba:

```powershell
docker compose ps
```

Deben aparecer **8 contenedores** `loop-*` en estado **Up** (algunos tambi├®n **healthy**):

| Contenedor | Rol |
|------------|-----|
| `loop-db` | PostgreSQL |
| `loop-auth` | GoTrue (login / registro) |
| `loop-rest` | PostgREST (API tablas) |
| `loop-kong` | API Gateway (:54321) |
| `loop-meta` | Metadatos para Studio |
| `loop-storage` | Supabase Storage (im├ígenes) |
| `loop-imgproxy` | Transformaci├│n de im├ígenes |
| `loop-studio` | Supabase Studio (:54323) |

### 3. Inicializar base de datos

Ejecuta los scripts **en este orden**:

```powershell
# 1. Esquema: tablas, RLS, RPCs
powershell -ExecutionPolicy Bypass -File scripts\apply-schema.ps1

# 2. Storage: buckets avatars, events, posts, communities
powershell -ExecutionPolicy Bypass -File scripts\apply-storage.ps1

# 3. Cat├ílogo: regiones, comunas, intereses (necesario para registro y onboarding)
powershell -ExecutionPolicy Bypass -File scripts\seed-catalogo.ps1

# 4. Demo: usuarios, comunidades, eventos y publicaciones de prueba
powershell -ExecutionPolicy Bypass -File scripts\seed-demo.ps1
```

| Script | Archivo SQL | ┬┐Obligatorio? |
|--------|-------------|---------------|
| `apply-schema.ps1` | `docs/sql/loop_schema.sql` | **S├¡** (primera vez o volumen nuevo) |
| `apply-storage.ps1` | `docs/sql/loop_storage.sql` | **S├¡** (buckets de im├ígenes) |
| `seed-catalogo.ps1` | `docs/sql/loop_seed_catalogo.sql` | **S├¡** (sin esto no hay regiones/comunas/intereses) |
| `seed-demo.ps1` | `docs/sql/loop_seed_demo.sql` | Recomendado (login inmediato con cuentas demo) |

> **Nota:** En el primer arranque del volumen, Docker tambi├®n carga el esquema desde `docker/db/init/migrations/100-loop-schema.sql`. Aun as├¡ debes ejecutar los scripts anteriores: el cat├ílogo y los datos demo **no** se cargan solos.

### 4. Ejecutar la app Flutter

```powershell
flutter pub get
```

Configura los argumentos de ejecuci├│n en **Android Studio ÔåÆ Run ÔåÆ Edit Configurations ÔåÆ Additional run args** (o p├ísalos en la terminal con `flutter run`).

**Emulador Android** (`10.0.2.2` apunta al localhost de tu PC):

```
--dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

**Chrome / Web:**

```
--dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

**Celular f├¡sico** (misma WiFi; reemplaza la IP por la de tu PC ÔÇö `ipconfig` ÔåÆ IPv4):

```
--dart-define=SUPABASE_URL=http://192.168.1.50:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

### 5. Probar login

Con Docker en **Running** ÔåÆ Android Studio ÔåÆ **Run** ÔûÂ

Usa las credenciales demo (creadas por `seed-demo.ps1`):

| Rol | Email | Contrase├▒a |
|-----|-------|------------|
| Admin | `admin@loop.cl` | `LoopAdmin1` |
| Usuario | `user@loop.cl` | `LoopUser1` |
| Otros demo | `valentina.morales@loop.cl`, `diego.henriquez@loop.cl`, etc. | `LoopDemo1` |

Si omitiste `seed-demo.ps1`, puedes **registrar un usuario nuevo** en la app (requiere haber ejecutado `seed-catalogo.ps1`).

---

## URLs del entorno local

| URL | Uso |
|-----|-----|
| http://127.0.0.1:54321 | API Supabase (Auth + REST + Storage `/storage/v1/`) |
| http://127.0.0.1:54323 | Supabase Studio (explorar la BD) |
| http://127.0.0.1:54322 | PostgreSQL directo (solo diagn├│stico) |

**Anon key** (Supabase local ÔÇö incluida tambi├®n en `.env.example`):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

---

## Base de datos (SQL)

Fuente de verdad en `docs/sql/`:

| Archivo | Contenido |
|---------|-----------|
| `loop_schema.sql` | Tablas, RLS, RPCs (sin datos de demo) |
| `loop_storage.sql` | Buckets de im├ígenes, pol├¡ticas Storage, columna `cover_url` |
| `loop_seed_catalogo.sql` | Regiones, comunas, intereses |
| `loop_seed_demo.sql` | Usuarios, comunidades, eventos, posts |

Los scripts PowerShell en `scripts/` apuntan a esos archivos. **No ejecutes** los SQL sueltos de `docs/sql/archive/` (solo referencia hist├│rica).

### Cu├índo repetir los scripts

| Situaci├│n | Qu├® hacer |
|-----------|-----------|
| Primera instalaci├│n o `docker compose down -v` | Los **4 scripts** en orden (schema ÔåÆ storage ÔåÆ cat├ílogo ÔåÆ demo) |
| Agregaste Storage a un entorno ya existente | `apply-storage.ps1` (y `apply-schema.ps1` si falta `cover_url`) |
| Solo refrescar datos demo | `scripts\seed-demo.ps1` |
| Docker ya corriendo, BD intacta | No hace falta repetir |

> Las im├ígenes del seed demo son referencias en SQL; **no** suben archivos a Storage. Las fotos reales en buckets las generas al crear posts, eventos, avatar o banner desde la app.

---

## Arquitectura

```
Flutter (Android / Web)
        Ôöé
        Ôû╝
   Kong :54321  ÔåÉ API p├║blica
    Ôö£ÔöÇÔöÇ Auth (GoTrue)       ÔåÆ login / registro / JWT
    Ôö£ÔöÇÔöÇ REST (PostgREST)    ÔåÆ tablas public.*
    Ôö£ÔöÇÔöÇ Storage             ÔåÆ buckets avatars, events, posts, communities
    ÔööÔöÇÔöÇ Meta ÔåÆ Studio :54323
        Ôöé
        Ôû╝
   PostgreSQL :54322
        Ôû▓
   loop-storage + loop-imgproxy (archivos en volumen loop-storage-data)
```

---

## Verificaci├│n del ambiente

Checklist despu├®s de instalar:

- [ ] `docker compose ps` ÔåÆ **8** contenedores `loop-*` en **Up** (incluye `loop-storage` y `loop-imgproxy`)
- [ ] http://127.0.0.1:54323 abre Supabase Studio
- [ ] En Studio ÔåÆ **Storage** aparecen los buckets `avatars`, `events`, `posts`, `communities`
- [ ] Login con `user@loop.cl` / `LoopUser1` funciona
- [ ] El feed, explore y perfil muestran datos (requiere `seed-demo.ps1`)
- [ ] Registro de usuario nuevo crea fila en Auth + tabla `usuario`
- [ ] Crear un post o evento con imagen deja un archivo en el bucket correspondiente
- [ ] `flutter analyze` sin errores

---

## Soluci├│n de problemas

| Problema | Soluci├│n |
|----------|----------|
| `connection refused` en la app | Docker no est├í arriba, o URL incorrecta (emulador ÔåÆ `10.0.2.2`, no `127.0.0.1`) |
| Sin regiones/comunas al registrarse | Ejecuta `scripts\seed-catalogo.ps1` |
| Im├ígenes no se suben / solo color en eventos | Verifica `loop-storage` en `docker compose ps` y ejecuta `scripts\apply-storage.ps1` |
| Tablas vac├¡as o BD inconsistente | `docker compose down -v` ÔåÆ `up -d` ÔåÆ los **4 scripts** en orden |
| Puerto 54321 ocupado | Cierra el proceso conflictivo o cambia el mapeo en `docker-compose.yml` |
| Auth falla tras cambiar JWT en `.env` | Recrea el volumen: `docker compose down -v` y vuelve a levantar + scripts |

---

## Comandos ├║tiles

```powershell
# Atajo: copia .env si falta y levanta Docker
powershell -ExecutionPolicy Bypass -File scripts\start-backend.ps1

# Detener contenedores (conserva datos)
docker compose down

# Reinicio limpio (borra volumen y datos)
docker compose down -v
docker compose up -d
# Luego: apply-schema ÔåÆ apply-storage ÔåÆ seed-catalogo ÔåÆ seed-demo

# Build APK de prueba
flutter build apk --debug
```

---

## Estructura del proyecto

```
eventosloop/
Ôö£ÔöÇÔöÇ lib/                  # App Flutter (features)
Ôö£ÔöÇÔöÇ docs/sql/             # SQL activo + archive
Ôö£ÔöÇÔöÇ scripts/              # apply-schema, apply-storage, seed-catalogo, seed-demo
Ôö£ÔöÇÔöÇ docker/               # Init scripts Postgres + Kong
Ôö£ÔöÇÔöÇ docker-compose.yml    # Stack Supabase local (8 servicios)
ÔööÔöÇÔöÇ .env.example          # Variables de entorno (copiar a .env)
```

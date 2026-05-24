# LOOP (`eventosloop`)

App Flutter para descubrir eventos y comunidades, con backend local Supabase self-hosted en Docker.

---

## Requisitos

| Herramienta | Uso |
|-------------|-----|
| **Docker Desktop** | Backend (Postgres, Auth, API, Studio) |
| **Flutter SDK** | App móvil / web |
| **Android Studio** | Emulador Android (o Chrome para web) |
| **PowerShell** | Scripts de base de datos (Windows) |

---

## Guía rápida: clonar y probar

Sigue estos pasos en orden la **primera vez** que clones el repo (o después de `docker compose down -v`).

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

Comprobar que todo esté arriba:

```powershell
docker compose ps
```

Deben aparecer **8 contenedores** `loop-*` en estado **Up** (algunos también **healthy**):

| Contenedor | Rol |
|------------|-----|
| `loop-db` | PostgreSQL |
| `loop-auth` | GoTrue (login / registro) |
| `loop-rest` | PostgREST (API tablas) |
| `loop-kong` | API Gateway (:54321) |
| `loop-meta` | Metadatos para Studio |
| `loop-storage` | Supabase Storage (imágenes) |
| `loop-imgproxy` | Transformación de imágenes |
| `loop-studio` | Supabase Studio (:54323) |

### 3. Inicializar base de datos

Ejecuta los scripts **en este orden**:

```powershell
# 1. Esquema: tablas, RLS, RPCs
powershell -ExecutionPolicy Bypass -File scripts\apply-schema.ps1

# 2. Storage: buckets avatars, events, posts, communities
powershell -ExecutionPolicy Bypass -File scripts\apply-storage.ps1

# 3. Catálogo: regiones, comunas, intereses (necesario para registro y onboarding)
powershell -ExecutionPolicy Bypass -File scripts\seed-catalogo.ps1

# 4. Demo: usuarios, comunidades, eventos y publicaciones de prueba
powershell -ExecutionPolicy Bypass -File scripts\seed-demo.ps1
```

| Script | Archivo SQL | ¿Obligatorio? |
|--------|-------------|---------------|
| `apply-schema.ps1` | `docs/sql/loop_schema.sql` | **Sí** (primera vez o volumen nuevo) |
| `apply-storage.ps1` | `docs/sql/loop_storage.sql` | **Sí** (buckets de imágenes) |
| `seed-catalogo.ps1` | `docs/sql/loop_seed_catalogo.sql` | **Sí** (sin esto no hay regiones/comunas/intereses) |
| `seed-demo.ps1` | `docs/sql/loop_seed_demo.sql` | Recomendado (login inmediato con cuentas demo) |

> **Nota:** En el primer arranque del volumen, Docker también carga el esquema desde `docker/db/init/migrations/100-loop-schema.sql`. Aun así debes ejecutar los scripts anteriores: el catálogo y los datos demo **no** se cargan solos.

### 4. Ejecutar la app Flutter

```powershell
flutter pub get
```

Configura los argumentos de ejecución en **Android Studio → Run → Edit Configurations → Additional run args** (o pásalos en la terminal con `flutter run`).

**Emulador Android** (`10.0.2.2` apunta al localhost de tu PC):

```
--dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

**Chrome / Web:**

```
--dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

**Celular físico** (misma WiFi; reemplaza la IP por la de tu PC — `ipconfig` → IPv4):

```
--dart-define=SUPABASE_URL=http://192.168.1.50:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

### 5. Probar login

Con Docker en **Running** → Android Studio → **Run** ▶

Usa las credenciales demo (creadas por `seed-demo.ps1`):

| Rol | Email | Contraseña |
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
| http://127.0.0.1:54322 | PostgreSQL directo (solo diagnóstico) |

**Anon key** (Supabase local — incluida también en `.env.example`):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

---

## Base de datos (SQL)

Fuente de verdad en `docs/sql/`:

| Archivo | Contenido |
|---------|-----------|
| `loop_schema.sql` | Tablas, RLS, RPCs (sin datos de demo) |
| `loop_storage.sql` | Buckets de imágenes, políticas Storage, columna `cover_url` |
| `loop_seed_catalogo.sql` | Regiones, comunas, intereses |
| `loop_seed_demo.sql` | Usuarios, comunidades, eventos, posts |

Los scripts PowerShell en `scripts/` apuntan a esos archivos. **No ejecutes** los SQL sueltos de `docs/sql/archive/` (solo referencia histórica).

### Cuándo repetir los scripts

| Situación | Qué hacer |
|-----------|-----------|
| Primera instalación o `docker compose down -v` | Los **4 scripts** en orden (schema → storage → catálogo → demo) |
| Agregaste Storage a un entorno ya existente | `apply-storage.ps1` (y `apply-schema.ps1` si falta `cover_url`) |
| Solo refrescar datos demo | `scripts\seed-demo.ps1` |
| Docker ya corriendo, BD intacta | No hace falta repetir |

> Las imágenes del seed demo son referencias en SQL; **no** suben archivos a Storage. Las fotos reales en buckets las generas al crear posts, eventos, avatar o banner desde la app.

---

## Arquitectura

```
Flutter (Android / Web)
        │
        ▼
   Kong :54321  ← API pública
    ├── Auth (GoTrue)       → login / registro / JWT
    ├── REST (PostgREST)    → tablas public.*
    ├── Storage             → buckets avatars, events, posts, communities
    └── Meta → Studio :54323
        │
        ▼
   PostgreSQL :54322
        ▲
   loop-storage + loop-imgproxy (archivos en volumen loop-storage-data)
```

---

## Verificación del ambiente

Checklist después de instalar:

- [ ] `docker compose ps` → **8** contenedores `loop-*` en **Up** (incluye `loop-storage` y `loop-imgproxy`)
- [ ] http://127.0.0.1:54323 abre Supabase Studio
- [ ] En Studio → **Storage** aparecen los buckets `avatars`, `events`, `posts`, `communities`
- [ ] Login con `user@loop.cl` / `LoopUser1` funciona
- [ ] El feed, explore y perfil muestran datos (requiere `seed-demo.ps1`)
- [ ] Registro de usuario nuevo crea fila en Auth + tabla `usuario`
- [ ] Crear un post o evento con imagen deja un archivo en el bucket correspondiente
- [ ] `flutter analyze` sin errores

---

## Solución de problemas

| Problema | Solución |
|----------|----------|
| `connection refused` en la app | Docker no está arriba, o URL incorrecta (emulador → `10.0.2.2`, no `127.0.0.1`) |
| Sin regiones/comunas al registrarse | Ejecuta `scripts\seed-catalogo.ps1` |
| Imágenes no se suben / solo color en eventos | Verifica `loop-storage` en `docker compose ps` y ejecuta `scripts\apply-storage.ps1` |
| Tablas vacías o BD inconsistente | `docker compose down -v` → `up -d` → los **4 scripts** en orden |
| Puerto 54321 ocupado | Cierra el proceso conflictivo o cambia el mapeo en `docker-compose.yml` |
| Auth falla tras cambiar JWT en `.env` | Recrea el volumen: `docker compose down -v` y vuelve a levantar + scripts |

---

## Comandos útiles

```powershell
# Atajo: copia .env si falta y levanta Docker
powershell -ExecutionPolicy Bypass -File scripts\start-backend.ps1

# Detener contenedores (conserva datos)
docker compose down

# Reinicio limpio (borra volumen y datos)
docker compose down -v
docker compose up -d
# Luego: apply-schema → apply-storage → seed-catalogo → seed-demo

# Build APK de prueba
flutter build apk --debug
```

---

## Estructura del proyecto

```
eventosloop/
├── lib/                  # App Flutter (features)
├── docs/sql/             # SQL activo + archive
├── scripts/              # apply-schema, apply-storage, seed-catalogo, seed-demo
├── docker/               # Init scripts Postgres + Kong
├── docker-compose.yml    # Stack Supabase local (8 servicios)
└── .env.example          # Variables de entorno (copiar a .env)
```

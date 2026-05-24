# LOOP (`eventosloop`)

App Flutter para descubrir eventos y comunidades, con backend local Supabase en Docker.

---

## Requisitos

1. **Docker Desktop** (en ejecución).
2. **Flutter SDK** (`flutter doctor`).
3. **Android Studio** (emulador Android) o **Chrome** (web).
4. **PowerShell** (Windows).

---

## Instrucciones (primera vez)

Sigue los pasos **en este orden**. También aplica después de `docker compose down -v`.

### 1. Clonar el repositorio

```powershell
git clone https://github.com/fcomendez/eventosloop.git
cd eventosloop
```

### 2. Configurar variables de entorno

```powershell
copy .env.example .env
```

### 3. Levantar el backend (Docker)

Opción A — atajo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\start-backend.ps1
```

Opción B — manual:

```powershell
docker compose up -d
```

### 4. Verificar que Docker esté activo

```powershell
docker compose ps
```

Deben aparecer **8 contenedores** `loop-*` en estado **Up**:

| Contenedor | Función |
|------------|---------|
| `loop-db` | Base de datos |
| `loop-auth` | Login y registro |
| `loop-rest` | API de tablas |
| `loop-kong` | Puerta de entrada (puerto 54321) |
| `loop-meta` | Metadatos para Studio |
| `loop-storage` | Almacenamiento de imágenes |
| `loop-imgproxy` | Procesamiento de imágenes |
| `loop-studio` | Panel web (puerto 54323) |

### 5. Inicializar la base de datos

Ejecuta **los 4 scripts en orden**:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\apply-schema.ps1
powershell -ExecutionPolicy Bypass -File scripts\apply-storage.ps1
powershell -ExecutionPolicy Bypass -File scripts\seed-catalogo.ps1
powershell -ExecutionPolicy Bypass -File scripts\seed-demo.ps1
```

| Paso | Script | Para qué sirve |
|------|--------|----------------|
| 5.1 | `apply-schema.ps1` | Tablas, permisos y funciones |
| 5.2 | `apply-storage.ps1` | Buckets de imágenes |
| 5.3 | `seed-catalogo.ps1` | Regiones, comunas e intereses |
| 5.4 | `seed-demo.ps1` | Usuarios y datos de prueba |

### 6. Instalar dependencias de Flutter

```powershell
flutter pub get
```

### 7. Ejecutar la app

Pasa estos argumentos al correr (`flutter run` o Android Studio → **Additional run args**).

**Anon key** (local, incluida en `.env.example`):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

**7.1 Emulador Android** (usa `10.0.2.2` para llegar al PC):

```powershell
flutter run --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

**7.2 Chrome / Web**:

```powershell
flutter run -d chrome --dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

**7.3 Celular físico** (misma red Wi‑Fi; cambia la IP por la de tu PC — `ipconfig`):

```powershell
flutter run --dart-define=SUPABASE_URL=http://192.168.1.50:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

### 8. Probar login

Con Docker en ejecución, abre la app e inicia sesión:

| Rol | Correo | Contraseña |
|-----|--------|------------|
| Admin | `admin@loop.cl` | `LoopAdmin1` |
| Usuario | `user@loop.cl` | `LoopUser1` |
| Otros demo | `valentina.morales@loop.cl`, `diego.henriquez@loop.cl`, etc. | `LoopDemo1` |

Comprueba también:

1. El **feed** y **explorar** muestran contenido.
2. Puedes **crear un evento o publicación** con imagen.
3. En http://127.0.0.1:54323 (Studio) → **Storage** existen los buckets `avatars`, `events`, `posts`, `communities`.

Si omitiste el paso 5.4, puedes **registrar un usuario nuevo** (requiere haber ejecutado el paso 5.3).

---

## URLs locales

| URL | Uso |
|-----|-----|
| http://127.0.0.1:54321 | API (Auth, REST, Storage) |
| http://127.0.0.1:54323 | Supabase Studio |
| http://127.0.0.1:54322 | PostgreSQL (solo diagnóstico) |

---

## Problemas frecuentes

| Problema | Qué hacer |
|----------|-----------|
| `connection refused` en la app | Verifica Docker (`paso 4`). En emulador usa `10.0.2.2`, no `127.0.0.1`. |
| Sin regiones al registrarse | Ejecuta el paso 5.3 (`seed-catalogo.ps1`). |
| Imágenes no se suben | Verifica `loop-storage` en el paso 4 y ejecuta el paso 5.2. |
| Base de datos vacía o corrupta | `docker compose down -v` → repite desde el paso 3. |
| Puerto 54321 ocupado | Cierra el proceso que lo usa o cambia el puerto en `docker-compose.yml`. |

---

## Reinicio limpio (opcional)

Borra todos los datos y vuelve a empezar:

```powershell
docker compose down -v
docker compose up -d
```

Luego repite los **pasos 5 a 8**.

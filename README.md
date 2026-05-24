# LOOP (`eventosloop`)

App Flutter + backend Supabase local en Docker.

**Requisitos:** Docker Desktop encendido, Flutter, Android Studio (emulador) o Chrome.

---

## Comandos (en orden)

```powershell
git clone https://github.com/fcomendez/eventosloop.git
cd eventosloop
copy .env.example .env
docker compose up -d
docker compose ps
powershell -ExecutionPolicy Bypass -File scripts\apply-schema.ps1
powershell -ExecutionPolicy Bypass -File scripts\apply-storage.ps1
powershell -ExecutionPolicy Bypass -File scripts\seed-catalogo.ps1
powershell -ExecutionPolicy Bypass -File scripts\seed-demo.ps1
flutter pub get
flutter run --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

`docker compose ps` debe mostrar **8** contenedores `loop-*` en **Up**.

**Chrome en vez de emulador** — cambia solo la URL:

```powershell
flutter run -d chrome --dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

---

## Login demo

| Correo | Contraseña |
|--------|------------|
| `admin@loop.cl` | `LoopAdmin1` |
| `user@loop.cl` | `LoopUser1` |

---

## Si algo falla

```powershell
docker compose down -v
docker compose up -d
```

Luego repite desde `apply-schema.ps1` hasta `flutter run`.

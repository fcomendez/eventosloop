# Integracion Supabase (LOOP)

Guia para conectar el proyecto Flutter con Supabase local (Docker).

## 0) Backend local (Docker)

```powershell
copy .env.example .env
docker compose up -d
```

Ver `README.md` y `docs/ambiente-pruebas.md` para contenedores, puertos y backup.

- API: `http://127.0.0.1:54321`
- Emulador Android: `http://10.0.2.2:54321`
- Anon key demo: ver `.env.example`

## 1) Variables Flutter

Opcional si usas los defaults de `app_env.dart` (Supabase local):

```bash
--dart-define=SUPABASE_URL=http://10.0.2.2:54321
--dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

En Android Studio (Run Configuration Flutter), agregalas en **Additional run args**.

## 2) Inicializacion

`lib/main.dart` inicializa Supabase si detecta URL y anon key.

## 3) Flujo auth implementado

- Login correo/password -> `supabase.auth.signInWithPassword`
- Registro -> `supabase.auth.signUp` + upsert `usuario`
- Recuperacion correo -> `supabase.auth.resetPasswordForEmail`
- OTP recovery -> `supabase.auth.verifyOTP(type: recovery)`
- Cambio password -> `supabase.auth.updateUser(password: ...)`

## 4) Esquema de BD

El esquema completo se aplica al crear el volumen Docker desde:

- `docker/db/init/migrations/100-loop-schema.sql` (fuente: `docs/sql/schema_completo.sql`)

Scripts adicionales por tabla en `docs/sql/`.

## 5) RLS base sugerida

Incluida en `schema_completo.sql`. Ejemplo minimo para `usuario`:

```sql
alter table public.usuario enable row level security;

create policy "usuario_select_own"
on public.usuario
for select
to authenticated
using (auth_user_id = auth.uid());
```

## 6) Intereses (MER: `intereses` + `usuario_intereses`)

Script: `docs/sql/intereses_usuario_intereses.sql` (incluido en schema completo si ya ejecutaste Docker init).

## 7) Verificacion rapida

1. `docker compose ps` — contenedores running
2. Registro en app — usuario en Auth + tabla `usuario`
3. Login — sesion activa y navegacion post-auth

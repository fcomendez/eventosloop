# Integracion Supabase (LOOP)

Guia para conectar el proyecto Flutter con Supabase sin romper la arquitectura actual.

## 1) Variables requeridas

Usa `--dart-define` para no hardcodear llaves:

```bash
--dart-define=SUPABASE_URL=TU_SUPABASE_URL
--dart-define=SUPABASE_ANON_KEY=TU_SUPABASE_ANON_KEY
```

En Android Studio (Run Configuration Flutter), agregalas en **Additional run args**.

## 2) Inicializacion

`lib/main.dart` inicializa Supabase solo si detecta ambas variables.

## 3) Flujo auth implementado

- Login correo/password -> `supabase.auth.signInWithPassword`
- Login Google -> `supabase.auth.signInWithIdToken`
- Recuperacion correo -> `supabase.auth.resetPasswordForEmail`
- OTP recovery -> `supabase.auth.verifyOTP(type: recovery)`
- Cambio password -> `supabase.auth.updateUser(password: ...)`

## 4) Tabla de negocio recomendada (MER + Supabase)

Ejecuta en SQL Editor de Supabase:

```sql
create table if not exists public.usuario (
  id_usuario bigint generated always as identity primary key,
  auth_user_id uuid unique references auth.users(id) on delete cascade,
  email text unique not null,
  username text,
  nombres text,
  apellidos text,
  fecha_nacimiento date,
  genero text,
  avatar_url text,
  estado_cuenta text default 'ACTIVO',
  rol_user text default 'USER',
  comuna_id_comuna bigint,
  fecha_registro timestamptz default now()
);
```

> Nota: `estado_cuenta` y `rol_user` deben manejarse de forma interna, no desde el formulario.

## 5) RLS base sugerida

```sql
alter table public.usuario enable row level security;

create policy "usuario_select_own"
on public.usuario
for select
to authenticated
using (auth_user_id = auth.uid());

create policy "usuario_update_own"
on public.usuario
for update
to authenticated
using (auth_user_id = auth.uid());

create policy "usuario_insert_own"
on public.usuario
for insert
to authenticated
with check (auth_user_id = auth.uid());
```

## 6) Flujo Git recomendado

- Rama de trabajo: `Franco`
- Commits pequenos por tema:
  - `feat(supabase): init y variables`
  - `feat(auth): login/register supabase`
  - `feat(auth): recovery otp`

Esto permite avanzar interfaz y backend en paralelo con menor riesgo de conflictos.

## 7) Intereses (MER: `intereses` + `usuario_intereses`)

Para respetar la normalizacion de datos del MER (sin texto libre en `usuario`):

1. Abre Supabase -> SQL Editor.
2. Ejecuta completo el script:
   - `docs/sql/intereses_usuario_intereses.sql`

Ese script crea:
- `public.intereses` (catalogo maestro)
- `public.usuario_intereses` (tabla puente N:N con `auth.users`)
- indices para lectura rapida
- politicas RLS para que cada usuario solo manipule sus propios intereses
- una semilla inicial de ejemplo (luego se reemplaza con tu listado final)

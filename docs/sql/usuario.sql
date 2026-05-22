-- LOOP / Supabase — MER: usuario
-- Requiere: comuna.sql
-- password_hash va en auth.users (Supabase Auth).

create table if not exists public.usuario (
  id_usuario bigint generated always as identity primary key,
  auth_user_id uuid unique references auth.users(id) on delete cascade,
  email text unique not null,
  username text unique,
  nombres text,
  apellidos text,
  fecha_nacimiento date,
  fecha_registro timestamptz not null default now(),
  genero text,
  token_recuperacion text,
  expiracion_token timestamptz,
  avatar_url text,
  estado_cuenta text not null default 'ACTIVO',
  rol_user text not null default 'USER',
  comuna_id_comuna bigint references public.comuna(id_comuna) on delete set null
);

create index if not exists idx_usuario_auth_user_id
  on public.usuario(auth_user_id);

create index if not exists idx_usuario_comuna
  on public.usuario(comuna_id_comuna);

alter table public.usuario enable row level security;

drop policy if exists usuario_select_authenticated on public.usuario;
create policy usuario_select_authenticated
on public.usuario
for select
to authenticated
using (estado_cuenta = 'ACTIVO');

drop policy if exists usuario_insert_own on public.usuario;
create policy usuario_insert_own
on public.usuario
for insert
to authenticated
with check (auth_user_id = auth.uid());

drop policy if exists usuario_update_own on public.usuario;
create policy usuario_update_own
on public.usuario
for update
to authenticated
using (auth_user_id = auth.uid())
with check (auth_user_id = auth.uid());

-- LOOP / Supabase — MER: comunidades
-- Requiere: usuario.sql

create table if not exists public.comunidades (
  id_comunidad bigint generated always as identity primary key,
  nombre text not null,
  descripcion text,
  banner_url text,
  privacidad text not null default 'PUBLICA',
  estado text not null default 'PENDIENTE',
  fecha_creacion timestamptz not null default now(),
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade
);

create index if not exists idx_comunidades_creador
  on public.comunidades(usuario_id_usuario);

alter table public.comunidades enable row level security;

drop policy if exists comunidades_select_authenticated on public.comunidades;
create policy comunidades_select_authenticated
on public.comunidades
for select
to authenticated
using (true);

drop policy if exists comunidades_insert_own on public.comunidades;
create policy comunidades_insert_own
on public.comunidades
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists comunidades_update_owner on public.comunidades;
create policy comunidades_update_owner
on public.comunidades
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists comunidades_delete_owner on public.comunidades;
create policy comunidades_delete_owner
on public.comunidades
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

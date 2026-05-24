-- LOOP / Supabase — MER: roles_sistema
-- Requiere: usuario.sql
-- Asignacion de roles administrativos por usuario (ADMIN, MODERADOR, etc.).

create table if not exists public.roles_sistema (
  id_roll bigint generated always as identity primary key,
  nombre_rol text not null,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  created_at timestamptz not null default now(),
  unique (usuario_id_usuario, nombre_rol)
);

create index if not exists idx_roles_sistema_usuario
  on public.roles_sistema(usuario_id_usuario);

create index if not exists idx_roles_sistema_nombre
  on public.roles_sistema(nombre_rol);

-- Helper para politicas RLS de moderacion/auditoria.
create or replace function public.es_admin_o_moderador()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.roles_sistema rs
    inner join public.usuario u on u.id_usuario = rs.usuario_id_usuario
    where u.auth_user_id = auth.uid()
      and rs.nombre_rol in ('ADMIN', 'MODERADOR')
  )
  or exists (
    select 1
    from public.usuario u
    where u.auth_user_id = auth.uid()
      and u.rol_user in ('ADMIN', 'MODERADOR')
  );
$$;

alter table public.roles_sistema enable row level security;

drop policy if exists roles_sistema_select_authenticated on public.roles_sistema;
create policy roles_sistema_select_authenticated
on public.roles_sistema
for select
to authenticated
using (true);

drop policy if exists roles_sistema_insert_admin on public.roles_sistema;
create policy roles_sistema_insert_admin
on public.roles_sistema
for insert
to authenticated
with check (public.es_admin_o_moderador());

drop policy if exists roles_sistema_update_admin on public.roles_sistema;
create policy roles_sistema_update_admin
on public.roles_sistema
for update
to authenticated
using (public.es_admin_o_moderador());

drop policy if exists roles_sistema_delete_admin on public.roles_sistema;
create policy roles_sistema_delete_admin
on public.roles_sistema
for delete
to authenticated
using (public.es_admin_o_moderador());

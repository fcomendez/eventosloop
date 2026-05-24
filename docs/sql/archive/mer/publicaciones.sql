-- LOOP / Supabase — MER: publicaciones
-- Requiere: usuario.sql, comunidades.sql

create table if not exists public.publicaciones (
  id_post bigint generated always as identity primary key,
  titulo text,
  contenido text not null,
  url_media text,
  fecha_publicacion timestamptz not null default now(),
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  comunidades_id_comunidad bigint references public.comunidades(id_comunidad) on delete set null
);

create index if not exists idx_publicaciones_usuario
  on public.publicaciones(usuario_id_usuario);

create index if not exists idx_publicaciones_comunidad
  on public.publicaciones(comunidades_id_comunidad);

create index if not exists idx_publicaciones_fecha
  on public.publicaciones(fecha_publicacion desc);

alter table public.publicaciones enable row level security;

drop policy if exists publicaciones_select_authenticated on public.publicaciones;
create policy publicaciones_select_authenticated
on public.publicaciones
for select
to authenticated
using (true);

drop policy if exists publicaciones_insert_own on public.publicaciones;
create policy publicaciones_insert_own
on public.publicaciones
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists publicaciones_update_own on public.publicaciones;
create policy publicaciones_update_own
on public.publicaciones
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists publicaciones_delete_own on public.publicaciones;
create policy publicaciones_delete_own
on public.publicaciones
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

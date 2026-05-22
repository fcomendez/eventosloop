-- LOOP / Supabase — MER: reporte_publicacion
-- Requiere: publicaciones.sql, usuario.sql, roles_sistema.sql (funcion es_admin_o_moderador)

create table if not exists public.reporte_publicacion (
  id_reporte bigint generated always as identity primary key,
  motivo text not null,
  descripcion text,
  estado text not null default 'PENDIENTE',
  fecha_reporte timestamptz not null default now(),
  fecha_resolucion timestamptz,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  publicaciones_id_post bigint not null references public.publicaciones(id_post) on delete cascade,
  moderador_id_usuario bigint references public.usuario(id_usuario) on delete set null
);

create index if not exists idx_reporte_publicacion_post
  on public.reporte_publicacion(publicaciones_id_post);

create index if not exists idx_reporte_publicacion_estado
  on public.reporte_publicacion(estado);

create index if not exists idx_reporte_publicacion_reporter
  on public.reporte_publicacion(usuario_id_usuario);

alter table public.reporte_publicacion enable row level security;

drop policy if exists reporte_publicacion_select_own_or_admin on public.reporte_publicacion;
create policy reporte_publicacion_select_own_or_admin
on public.reporte_publicacion
for select
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
  or public.es_admin_o_moderador()
);

drop policy if exists reporte_publicacion_insert_own on public.reporte_publicacion;
create policy reporte_publicacion_insert_own
on public.reporte_publicacion
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists reporte_publicacion_update_admin on public.reporte_publicacion;
create policy reporte_publicacion_update_admin
on public.reporte_publicacion
for update
to authenticated
using (public.es_admin_o_moderador());

-- LOOP / Supabase — MER: adm_log
-- Requiere: usuario.sql, roles_sistema.sql (funcion es_admin_o_moderador)
-- Auditoria de acciones administrativas (moderacion, cambios de rol, etc.).

create table if not exists public.adm_log (
  id_log bigint generated always as identity primary key,
  accion_realizada text not null,
  detalle text,
  entidad_tipo text,
  entidad_id bigint,
  fecha_accion timestamptz not null default now(),
  usuario_id_usuario bigint references public.usuario(id_usuario) on delete set null
);

create index if not exists idx_adm_log_fecha
  on public.adm_log(fecha_accion desc);

create index if not exists idx_adm_log_usuario
  on public.adm_log(usuario_id_usuario);

create index if not exists idx_adm_log_entidad
  on public.adm_log(entidad_tipo, entidad_id);

alter table public.adm_log enable row level security;

drop policy if exists adm_log_select_admin on public.adm_log;
create policy adm_log_select_admin
on public.adm_log
for select
to authenticated
using (public.es_admin_o_moderador());

drop policy if exists adm_log_insert_admin on public.adm_log;
create policy adm_log_insert_admin
on public.adm_log
for insert
to authenticated
with check (
  public.es_admin_o_moderador()
  and (
    usuario_id_usuario is null
    or usuario_id_usuario in (
      select id_usuario from public.usuario where auth_user_id = auth.uid()
    )
  )
);

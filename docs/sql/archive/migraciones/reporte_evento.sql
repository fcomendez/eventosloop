-- LOOP / Supabase — reporte de eventos
-- Requiere: evento.sql, usuario.sql, roles_sistema.sql

create table if not exists public.reporte_evento (
  id_reporte bigint generated always as identity primary key,
  motivo text not null,
  descripcion text,
  estado text not null default 'PENDIENTE',
  fecha_reporte timestamptz not null default now(),
  fecha_resolucion timestamptz,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  evento_id_evento bigint not null references public.evento(id_evento) on delete cascade,
  moderador_id_usuario bigint references public.usuario(id_usuario) on delete set null
);

create index if not exists idx_reporte_evento_evento
  on public.reporte_evento(evento_id_evento);

create index if not exists idx_reporte_evento_estado
  on public.reporte_evento(estado);

alter table public.reporte_evento enable row level security;

drop policy if exists reporte_evento_select_own_or_admin on public.reporte_evento;
create policy reporte_evento_select_own_or_admin
on public.reporte_evento
for select
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
  or public.es_admin_o_moderador()
);

drop policy if exists reporte_evento_insert_own on public.reporte_evento;
create policy reporte_evento_insert_own
on public.reporte_evento
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists reporte_evento_update_admin on public.reporte_evento;
create policy reporte_evento_update_admin
on public.reporte_evento
for update
to authenticated
using (public.es_admin_o_moderador());

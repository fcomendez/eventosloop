-- LOOP / Supabase — MER: participantes_evento
-- Requiere: evento.sql, usuario.sql
-- Nota MER: se agrega usuario_id_usuario (necesario para inscripciones y solicitudes).

create table if not exists public.participantes_evento (
  id_participacion bigint generated always as identity primary key,
  evento_id_evento bigint not null references public.evento(id_evento) on delete cascade,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  estado_solicitud text not null default 'PENDIENTE',
  fecha_solicitud timestamptz not null default now(),
  unique (evento_id_evento, usuario_id_usuario)
);

create index if not exists idx_participantes_evento_usuario
  on public.participantes_evento(usuario_id_usuario);

create index if not exists idx_participantes_evento_estado
  on public.participantes_evento(estado_solicitud);

alter table public.participantes_evento enable row level security;

drop policy if exists participantes_evento_select_authenticated on public.participantes_evento;
create policy participantes_evento_select_authenticated
on public.participantes_evento
for select
to authenticated
using (true);

drop policy if exists participantes_evento_insert_own on public.participantes_evento;
create policy participantes_evento_insert_own
on public.participantes_evento
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists participantes_evento_update_owner_or_organizer on public.participantes_evento;
create policy participantes_evento_update_owner_or_organizer
on public.participantes_evento
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
  or evento_id_evento in (
    select e.id_evento
    from public.evento e
    inner join public.usuario u on u.id_usuario = e.usuario_id_usuario
    where u.auth_user_id = auth.uid()
  )
);

drop policy if exists participantes_evento_delete_own on public.participantes_evento;
create policy participantes_evento_delete_own
on public.participantes_evento
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

-- LOOP — Fase 2 comunidades: estado, intereses, RLS privacidad, RPCs admin/moderadores
-- Ejecutar DESPUES de apply-schema.ps1 (re-ejecutable)

-- Helpers
create or replace function public.usuario_actual_id()
returns bigint
language sql
stable
security definer
set search_path = public
as $$
  select id_usuario from public.usuario where auth_user_id = auth.uid() limit 1;
$$;

create or replace function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.usuario u
    where u.auth_user_id = auth.uid()
      and u.rol_user = 'ADMIN'
  )
  or exists (
    select 1
    from public.roles_sistema rs
    inner join public.usuario u on u.id_usuario = rs.usuario_id_usuario
    where u.auth_user_id = auth.uid()
      and rs.nombre_rol = 'ADMIN'
  );
$$;

create or replace function public.es_miembro_comunidad(p_comunidad_id bigint)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.miembro_comunidad mc
    where mc.id_comunidad = p_comunidad_id
      and mc.usuario_id_usuario = public.usuario_actual_id()
  );
$$;

create or replace function public.es_lider_comunidad(p_comunidad_id bigint)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.miembro_comunidad mc
    where mc.id_comunidad = p_comunidad_id
      and mc.usuario_id_usuario = public.usuario_actual_id()
      and mc.rol = 'LIDER'
  );
$$;

-- Columna estado en comunidades
alter table public.comunidades
  add column if not exists estado text not null default 'PENDIENTE';

alter table public.comunidades
  drop constraint if exists comunidades_estado_check;
alter table public.comunidades
  add constraint comunidades_estado_check
  check (estado in ('PENDIENTE', 'ACTIVA', 'BLOQUEADA'));

alter table public.comunidades
  drop constraint if exists comunidades_privacidad_check;
alter table public.comunidades
  add constraint comunidades_privacidad_check
  check (privacidad in ('PUBLICA', 'PRIVADA'));

create index if not exists idx_comunidades_estado
  on public.comunidades(estado);

create index if not exists idx_comunidades_privacidad
  on public.comunidades(privacidad);

-- Tabla puente comunidad_intereses
create table if not exists public.comunidad_intereses (
  id_comunidad bigint not null references public.comunidades(id_comunidad) on delete cascade,
  id_interes bigint not null references public.intereses(id_interes) on delete cascade,
  primary key (id_comunidad, id_interes)
);

create index if not exists idx_comunidad_intereses_interes
  on public.comunidad_intereses(id_interes);

alter table public.comunidad_intereses enable row level security;

-- RLS comunidades: filtrar privadas y pendientes
drop policy if exists comunidades_select_authenticated on public.comunidades;
drop policy if exists comunidades_select_visible on public.comunidades;
create policy comunidades_select_visible
on public.comunidades
for select
to authenticated
using (
  public.es_admin()
  or usuario_id_usuario = public.usuario_actual_id()
  or (
    estado = 'ACTIVA'
    and (
      privacidad = 'PUBLICA'
      or public.es_miembro_comunidad(id_comunidad)
    )
  )
);

drop policy if exists comunidades_insert_own on public.comunidades;
create policy comunidades_insert_own
on public.comunidades
for insert
to authenticated
with check (
  usuario_id_usuario = public.usuario_actual_id()
  and estado = 'PENDIENTE'
);

drop policy if exists comunidades_update_owner on public.comunidades;
create policy comunidades_update_owner
on public.comunidades
for update
to authenticated
using (
  usuario_id_usuario = public.usuario_actual_id()
  and estado = 'PENDIENTE'
);

drop policy if exists comunidades_update_admin on public.comunidades;
create policy comunidades_update_admin
on public.comunidades
for update
to authenticated
using (public.es_admin());

-- RLS comunidad_intereses
drop policy if exists comunidad_intereses_select_visible on public.comunidad_intereses;
create policy comunidad_intereses_select_visible
on public.comunidad_intereses
for select
to authenticated
using (
  exists (
    select 1
    from public.comunidades c
    where c.id_comunidad = comunidad_intereses.id_comunidad
      and (
        public.es_admin()
        or c.usuario_id_usuario = public.usuario_actual_id()
        or (
          c.estado = 'ACTIVA'
          and (
            c.privacidad = 'PUBLICA'
            or public.es_miembro_comunidad(c.id_comunidad)
          )
        )
      )
  )
);

-- RLS miembro_comunidad: permitir update de rol por lider/admin
drop policy if exists miembro_comunidad_update_rol on public.miembro_comunidad;
create policy miembro_comunidad_update_rol
on public.miembro_comunidad
for update
to authenticated
using (
  public.es_admin()
  or public.es_lider_comunidad(id_comunidad)
);

-- RPC: solicitar crear comunidad (queda PENDIENTE)
create or replace function public.solicitar_comunidad(
  p_nombre text,
  p_descripcion text,
  p_privacidad text default 'PUBLICA',
  p_interes_ids bigint[] default '{}'
)
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid bigint;
  v_id bigint;
  v_interes bigint;
begin
  v_uid := public.usuario_actual_id();
  if v_uid is null then
    raise exception 'Usuario no encontrado';
  end if;
  if p_nombre is null or length(trim(p_nombre)) < 3 then
    raise exception 'El nombre debe tener al menos 3 caracteres';
  end if;
  if p_privacidad not in ('PUBLICA', 'PRIVADA') then
    raise exception 'Privacidad invalida';
  end if;

  insert into public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  )
  values (
    trim(p_nombre), nullif(trim(coalesce(p_descripcion, '')), ''),
    p_privacidad, 'PENDIENTE', v_uid
  )
  returning id_comunidad into v_id;

  foreach v_interes in array coalesce(p_interes_ids, '{}')
  loop
    insert into public.comunidad_intereses (id_comunidad, id_interes)
    values (v_id, v_interes)
    on conflict do nothing;
  end loop;

  return v_id;
end;
$$;

-- RPC: admin aprueba PENDIENTE -> ACTIVA
create or replace function public.aprobar_comunidad(p_id_comunidad bigint)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner bigint;
begin
  if not public.es_admin() then
    raise exception 'No autorizado';
  end if;

  update public.comunidades
  set estado = 'ACTIVA'
  where id_comunidad = p_id_comunidad
    and estado = 'PENDIENTE'
  returning usuario_id_usuario into v_owner;

  if v_owner is null then
    raise exception 'Comunidad no encontrada o ya procesada';
  end if;

  insert into public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  values (p_id_comunidad, v_owner, 'LIDER')
  on conflict (id_comunidad, usuario_id_usuario) do update set rol = 'LIDER';
end;
$$;

-- RPC: asignar rol de miembro (MODERADOR, MIEMBRO, LIDER)
create or replace function public.asignar_rol_miembro_comunidad(
  p_id_comunidad bigint,
  p_usuario_id bigint,
  p_rol text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_rol not in ('MIEMBRO', 'MODERADOR', 'LIDER') then
    raise exception 'Rol invalido';
  end if;
  if not (public.es_admin() or public.es_lider_comunidad(p_id_comunidad)) then
    raise exception 'No autorizado';
  end if;

  update public.miembro_comunidad
  set rol = p_rol
  where id_comunidad = p_id_comunidad
    and usuario_id_usuario = p_usuario_id;

  if not found then
    raise exception 'Miembro no encontrado en la comunidad';
  end if;
end;
$$;

grant execute on function public.solicitar_comunidad(text, text, text, bigint[]) to authenticated;
grant execute on function public.aprobar_comunidad(bigint) to authenticated;
grant execute on function public.asignar_rol_miembro_comunidad(bigint, bigint, text) to authenticated;

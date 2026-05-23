-- LOOP — Migracion Fase 1 (SEGURA)
-- No crea tablas. Solo defaults, 1 policy faltante y RPC de intereses.
-- Ejecutar en Supabase SQL Editor cuando inventario confirme huecos.
--
-- Tu base ya tiene las 16 tablas y casi todas las policies.
-- Este script completa lo minimo para: registro + onboarding intereses.

-- ---------------------------------------------------------------------------
-- 1) Defaults en usuario (evita NULL en estado_cuenta / rol_user)
-- ---------------------------------------------------------------------------
alter table public.usuario
  alter column estado_cuenta set default 'ACTIVO';

alter table public.usuario
  alter column rol_user set default 'USER';

update public.usuario
set estado_cuenta = 'ACTIVO'
where estado_cuenta is null;

update public.usuario
set rol_user = 'USER'
where rol_user is null;

-- ---------------------------------------------------------------------------
-- 2) Region legible para usuarios autenticados
--    (tenias region_select_anon; comuna ya tiene anon + authenticated)
-- ---------------------------------------------------------------------------
drop policy if exists region_select_authenticated on public.region;
create policy region_select_authenticated
on public.region
for select
to authenticated
using (true);

-- ---------------------------------------------------------------------------
-- 3) RPC onboarding intereses (create or replace — no borra datos)
-- ---------------------------------------------------------------------------
create or replace function public.guardar_intereses_usuario(ids bigint[])
returns void
language plpgsql
security invoker
as $$
begin
  delete from public.usuario_intereses
  where auth_user_id = auth.uid();

  insert into public.usuario_intereses (auth_user_id, id_interes)
  select auth.uid(), unnest(ids);
end;
$$;

-- ---------------------------------------------------------------------------
-- Verificacion rapida (opcional, solo lectura)
-- ---------------------------------------------------------------------------
-- select routine_name from information_schema.routines
-- where routine_schema = 'public' and routine_name = 'guardar_intereses_usuario';
--
-- select tablename, policyname from pg_policies
-- where schemaname = 'public' and tablename = 'region';

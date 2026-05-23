-- LOOP — Inventario seguro (solo lectura)
-- Ejecutar en Supabase SQL Editor. No modifica nada.
-- Puedes enviar capturas de cada resultado.

-- A) Tablas public (deberias ver 16)
select table_name
from information_schema.tables
where table_schema = 'public'
order by table_name;

-- B) Columnas de usuario (la app usa estas en registro y feed)
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'public' and table_name = 'usuario'
order by ordinal_position;

-- C) RPC que usa onboarding de intereses
select routine_name, routine_type
from information_schema.routines
where routine_schema = 'public'
  and routine_name in ('guardar_intereses_usuario')
order by routine_name;

-- D) Policies de region/comuna (registro antes de login)
select tablename, policyname, roles, cmd
from pg_policies
where schemaname = 'public'
  and tablename in ('region', 'comuna', 'usuario', 'publicaciones')
order by tablename, policyname;

-- E) FK de publicaciones (feed)
select column_name
from information_schema.columns
where table_schema = 'public' and table_name = 'publicaciones'
order by ordinal_position;

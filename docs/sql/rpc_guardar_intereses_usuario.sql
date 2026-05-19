-- LOOP / Supabase
-- RPC: guardar intereses de usuario de forma atomica (transaccional).
-- Si falla el insert, el delete se revierte automaticamente.

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

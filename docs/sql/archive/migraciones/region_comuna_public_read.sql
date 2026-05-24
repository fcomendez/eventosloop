-- Permite leer region y comuna durante el registro (usuario aun no autenticado).
-- Ejecutar en Supabase SQL Editor si el formulario de registro no carga ubicaciones.

drop policy if exists region_select_anon on public.region;
create policy region_select_anon
on public.region
for select
to anon
using (true);

drop policy if exists comuna_select_anon on public.comuna;
create policy comuna_select_anon
on public.comuna
for select
to anon
using (true);

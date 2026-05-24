-- Seed demo: comunidades ACTIVAS con intereses (tags en UI) + 1 privada oculta en exploracion
-- Ejecutar DESPUES de seed_usuarios_demo.sql y migracion_comunidades_fase2.sql

DO $$
DECLARE
  v_admin_id bigint;
  v_user_id bigint;
  v_c1 bigint;
  v_c2 bigint;
  v_c3 bigint;
  v_c_priv bigint;
  v_interes_tech bigint;
  v_interes_yoga bigint;
  v_interes_foto bigint;
  v_interes_net bigint;
BEGIN
  SELECT id_usuario INTO v_admin_id FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1;
  SELECT id_usuario INTO v_user_id FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1;

  IF v_admin_id IS NULL OR v_user_id IS NULL THEN
    RAISE EXCEPTION 'Ejecuta seed_usuarios_demo.sql primero.';
  END IF;

  SELECT id_interes INTO v_interes_tech FROM public.intereses WHERE slug = 'videojuegos' LIMIT 1;
  SELECT id_interes INTO v_interes_yoga FROM public.intereses WHERE slug = 'yoga' LIMIT 1;
  SELECT id_interes INTO v_interes_foto FROM public.intereses WHERE slug = 'fotografia' LIMIT 1;
  SELECT id_interes INTO v_interes_net FROM public.intereses WHERE slug = 'networking' LIMIT 1;

  -- Limpiar seed anterior (re-ejecutable)
  DELETE FROM public.comunidad_intereses
  WHERE id_comunidad IN (
    SELECT id_comunidad FROM public.comunidades
    WHERE nombre IN (
      'Tech Founders Circle',
      'Mindful Mornings',
      'Creative Collective',
      'Club Privado LOOP'
    )
  );
  DELETE FROM public.miembro_comunidad
  WHERE id_comunidad IN (
    SELECT id_comunidad FROM public.comunidades
    WHERE nombre IN (
      'Tech Founders Circle',
      'Mindful Mornings',
      'Creative Collective',
      'Club Privado LOOP'
    )
  );
  DELETE FROM public.comunidades
  WHERE nombre IN (
    'Tech Founders Circle',
    'Mindful Mornings',
    'Creative Collective',
    'Club Privado LOOP'
  );

  -- Comunidad 1: Tech (publica, activa)
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Tech Founders Circle',
    'Comunidad para emprendedores tech que comparten experiencias y networking.',
    'PUBLICA', 'ACTIVA', v_admin_id
  ) RETURNING id_comunidad INTO v_c1;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c1, v_admin_id, 'LIDER');

  IF v_interes_tech IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c1, v_interes_tech);
  END IF;
  IF v_interes_net IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c1, v_interes_net);
  END IF;

  -- Comunidad 2: Bienestar (publica, activa)
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Mindful Mornings',
    'Rutinas matinales de yoga, meditacion y bienestar.',
    'PUBLICA', 'ACTIVA', v_user_id
  ) RETURNING id_comunidad INTO v_c2;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c2, v_user_id, 'LIDER'), (v_c2, v_admin_id, 'MIEMBRO');

  IF v_interes_yoga IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c2, v_interes_yoga);
  END IF;

  -- Comunidad 3: Arte (publica, activa)
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Creative Collective',
    'Espacio para fotografos, pintores y creadores visuales.',
    'PUBLICA', 'ACTIVA', v_admin_id
  ) RETURNING id_comunidad INTO v_c3;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c3, v_admin_id, 'LIDER');

  IF v_interes_foto IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c3, v_interes_foto);
  END IF;

  -- Comunidad privada: NO debe aparecer en exploracion para no-miembros
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Club Privado LOOP',
    'Comunidad privada solo visible para miembros invitados.',
    'PRIVADA', 'ACTIVA', v_admin_id
  ) RETURNING id_comunidad INTO v_c_priv;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c_priv, v_admin_id, 'LIDER');

END $$;

-- Seed demo: 4 eventos + 4 publicaciones por cada usuario demo
-- Ejecutar DESPUES de seed_comunidades_demo.sql

DO $$
DECLARE
  v_comuna bigint;
  v_c_tech bigint;
  v_c_yoga bigint;
  v_c_arte bigint;
  v_c_priv bigint;

  usr record;
BEGIN
  SELECT id_comuna INTO v_comuna FROM public.comuna ORDER BY id_comuna LIMIT 1;

  SELECT id_comunidad INTO v_c_tech FROM public.comunidades
  WHERE nombre = 'Tech Founders Circle' LIMIT 1;
  SELECT id_comunidad INTO v_c_yoga FROM public.comunidades
  WHERE nombre = 'Mindful Mornings' LIMIT 1;
  SELECT id_comunidad INTO v_c_arte FROM public.comunidades
  WHERE nombre = 'Creative Collective' LIMIT 1;
  SELECT id_comunidad INTO v_c_priv FROM public.comunidades
  WHERE nombre = 'Club Privado LOOP' LIMIT 1;

  IF v_comuna IS NULL THEN
    RAISE EXCEPTION 'No hay comunas. Ejecuta apply-schema.ps1 primero.';
  END IF;

  -- Limpiar contenido demo previo
  DELETE FROM public.publicaciones
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario
    WHERE email LIKE '%@loop.cl'
  );
  DELETE FROM public.evento
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario
    WHERE email LIKE '%@loop.cl'
  );

  FOR usr IN
    SELECT id_usuario, email, nombres, apellidos
    FROM public.usuario
    WHERE email IN (
      'admin@loop.cl',
      'user@loop.cl',
      'valentina.morales@loop.cl',
      'diego.henriquez@loop.cl',
      'camila.rosas@loop.cl',
      'matias.vega@loop.cl',
      'sofia.torres@loop.cl'
    )
    ORDER BY id_usuario
  LOOP
    -- 4 eventos por usuario
    INSERT INTO public.evento (
      nombre, titulo, descripcion, ubicacion_direccion, direccion,
      cupos_max, fecha_realizacion, estado, es_privado,
      usuario_id_usuario, comuna_id_comuna, comunidad_id_comunidad
    ) VALUES
      (
        'Meetup ' || usr.nombres,
        'Encuentro de comunidad con ' || usr.nombres,
        'Sesion abierta para compartir experiencias y conocer gente nueva.',
        'Parque Bustamante, Providencia',
        'Av. Providencia 1500',
        40,
        now() + interval '5 days',
        'ACTIVO', false,
        usr.id_usuario, v_comuna, v_c_tech
      ),
      (
        'Taller ' || usr.apellidos,
        'Workshop practico de ' || usr.nombres,
        'Actividad presencial con cupos limitados y dinamicas grupales.',
        'Centro Cultural Gabriela Mistral',
        'Av. Libertador Bernardo O Higgins 227',
        25,
        now() + interval '12 days',
        'ACTIVO', false,
        usr.id_usuario, v_comuna, v_c_yoga
      ),
      (
        'Networking ' || usr.nombres,
        'After office de networking',
        'Espacio para conectar profesionales del ecosistema local.',
        'WeWork Apoquindo',
        'Av. Apoquindo 5950',
        30,
        now() + interval '20 days',
        'ACTIVO', false,
        usr.id_usuario, v_comuna, v_c_arte
      ),
      (
        'Evento privado ' || usr.apellidos,
        'Sesion exclusiva para miembros',
        'Encuentro cerrado con acceso solo para invitados confirmados.',
        'Club LOOP, Las Condes',
        'Av. Las Condes 12345',
        15,
        now() + interval '28 days',
        'ACTIVO', true,
        usr.id_usuario, v_comuna, v_c_priv
      );

    -- 4 publicaciones por usuario
    INSERT INTO public.publicaciones (
      titulo, contenido, fecha_publicacion,
      usuario_id_usuario, comunidades_id_comunidad
    ) VALUES
      (
        'Hola desde ' || usr.nombres,
        'Mi primera publicacion en LOOP. Feliz de sumarme a la comunidad '
        || coalesce(
          (SELECT nombre FROM public.comunidades WHERE id_comunidad = v_c_tech),
          'Tech Founders Circle'
        ) || '.',
        now() - interval '6 days',
        usr.id_usuario, v_c_tech
      ),
      (
        'Reflexion de la semana',
        usr.nombres || ' ' || usr.apellidos || ' comparte: esta semana aprendi '
        'mucho escuchando a otros miembros. Gracias por el apoyo.',
        now() - interval '4 days',
        usr.id_usuario, v_c_yoga
      ),
      (
        'Fotos del ultimo encuentro',
        'Subiendo algunas imagenes del evento de ayer. Fue genial ver tanta '
        'energia en el espacio creativo.',
        now() - interval '2 days',
        usr.id_usuario, v_c_arte
      ),
      (
        'Proximo evento confirmado',
        'Ya tenemos fecha para el proximo meetup. Reserven cupo pronto, '
        'los lugares vuelan.',
        now() - interval '8 hours',
        usr.id_usuario, v_c_tech
      );
  END LOOP;

  -- Miembros extra en comunidades (mas alla del seed de comunidades)
  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  SELECT v_c_tech, u.id_usuario, 'MIEMBRO'
  FROM public.usuario u
  WHERE u.email IN (
    'valentina.morales@loop.cl',
    'diego.henriquez@loop.cl',
    'matias.vega@loop.cl'
  )
  ON CONFLICT DO NOTHING;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  SELECT v_c_yoga, u.id_usuario, 'MIEMBRO'
  FROM public.usuario u
  WHERE u.email IN (
    'camila.rosas@loop.cl',
    'sofia.torres@loop.cl',
    'user@loop.cl'
  )
  ON CONFLICT DO NOTHING;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  SELECT v_c_arte, u.id_usuario, 'MIEMBRO'
  FROM public.usuario u
  WHERE u.email IN (
    'camila.rosas@loop.cl',
    'valentina.morales@loop.cl',
    'sofia.torres@loop.cl'
  )
  ON CONFLICT DO NOTHING;

END $$;

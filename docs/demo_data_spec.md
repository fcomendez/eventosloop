# Especificación de datos demo — LOOP

Documento para generar un seed coherente: **50 usuarios**, **50 comunidades**, **50 eventos**, **100 publicaciones**, más interacciones sociales.

Las fotos (`avatar_url`, `banner_url`, `cover_url`, `url_media`) se cargan **después** por el equipo. En el seed dejar `NULL` o rutas placeholder documentadas.

---

## 1. Reglas globales de coherencia

### 1.1 Geografía (obligatorio)

Todo registro con ubicación debe cumplir:

| Regla | Ejemplo correcto | Ejemplo incorrecto |
|-------|------------------|-------------------|
| `comuna_id_comuna` debe existir en catálogo | Evento en Providencia → `id_comuna` de **Providencia** (RM) | Evento “en Santiago centro” con comuna **San Carlos** (Ñuble) |
| Texto de dirección debe coincidir con la comuna | `Av. Providencia 2653, Providencia` + comuna Providencia | `Plaza de Armas, Santiago` + comuna Maipú |
| Región implícita en textos opcionales debe coincidir | “Viña del Mar, Valparaíso” + comuna Viña del Mar | “Concepción” + comuna Santiago |

**Catálogo disponible:** `docs/sql/loop_seed_catalogo.sql` — 16 regiones, ~70 comunas, ~50 intereses con `slug` único.

**Distribución sugerida de los 50 usuarios y 50 eventos por región:**

| Región | Comunas a usar | Usuarios | Eventos |
|--------|----------------|----------|---------|
| Metropolitana de Santiago | Santiago, Providencia, Las Condes, Ñuñoa, Maipú, La Florida, Puente Alto | 18 | 18 |
| Valparaíso | Valparaíso, Viña del Mar, Quilpué, San Antonio | 6 | 6 |
| Biobío | Concepción, Talcahuano, Chiguayante | 6 | 6 |
| La Araucanía | Temuco, Villarrica, Padre Las Casas | 5 | 5 |
| Maule | Talca, Curicó, Linares | 4 | 4 |
| Coquimbo | La Serena, Coquimbo, Ovalle | 4 | 4 |
| O'Higgins | Rancagua, San Fernando | 3 | 3 |
| Los Lagos | Puerto Montt, Puerto Varas, Osorno | 2 | 2 |
| Ñuble | Chillán, San Carlos | 1 | 1 |
| Los Ríos | Valdivia | 1 | 1 |

### 1.2 Identificadores en base de datos

| Entidad | Tabla | PK | Notas |
|---------|-------|-----|-------|
| Usuario app | `public.usuario` | `id_usuario` (identity) | Enlazado a `auth.users` vía `auth_user_id` (UUID fijo en seed) |
| Comunidad | `public.comunidades` | `id_comunidad` | |
| Evento | `public.evento` | `id_evento` | |
| Publicación | `public.publicaciones` | `id_post` | |

**No hardcodear IDs numéricos** en el SQL generado salvo referencias cruzadas dentro del mismo script (variables PL/pgSQL o CTEs). Usar `email`, `nombre` de comunidad o `slug` de interés para resolver FKs.

### 1.3 Dominio y credenciales

| Campo | Valor |
|-------|-------|
| Dominio email | `@loop.cl` exclusivamente |
| Contraseña admin | `LoopAdmin1` |
| Contraseña resto | `LoopDemo1` |
| UUID auth | Prefijo fijo `aaaaaaaa-bbbb-cccc-dddd-` + número secuencial 4 dígitos (0001–0050) |

Usuarios existentes a **conservar o reemplazar** (decisión al ejecutar seed):

- `admin@loop.cl` — ADMIN
- `user@loop.cl` — USER de referencia

Los otros 48 usuarios nuevos usan patrón `nombre.apellido@loop.cl`.

### 1.4 RUT chileno

**La tabla `usuario` no tiene columna RUT** hoy. Generar RUT válidos (con dígito verificador correcto) solo si:

- se agrega columna en el futuro, o
- se guardan en CSV auxiliar para documentación.

Formato: `12.345.678-9` — usar algoritmo módulo 11. **No inventar RUT de personas reales**; usar rangos ficticios `15.xxx.xxx-x` a `26.xxx.xxx-x`.

---

## 2. Usuario (50 registros)

### 2.1 Campos obligatorios

| Campo | Tipo / valores | Reglas |
|-------|----------------|--------|
| `auth_user_id` | UUID | Uno por usuario, fijo en seed |
| `email` | text, unique | `@loop.cl`, minúsculas, sin tildes |
| `username` | text, unique | `nombre_apellido` o `nombre.a` — 3–20 chars, `[a-z0-9_.]` |
| `nombres` | text | Nombres chilenos creíbles, sin repetir >2 veces |
| `apellidos` | text | Apellidos chilenos (paterno + a veces materno corto) |
| `fecha_nacimiento` | date | Edad 18–45 años (fecha entre 1980-01-01 y 2007-12-31) |
| `genero` | text | `Masculino`, `Femenino` u `Otro` (app usa estos tres) |
| `comuna_id_comuna` | FK | Según tabla §1.1 — **residencia del usuario** |
| `rol_user` | text | 1× `ADMIN`, 1× `MODERADOR` (opcional), 48× `USER` |
| `estado_cuenta` | text | 48× `ACTIVO`, 2× `SUSPENDIDO` (para probar admin) |
| `telefono` | text | `+569` + 8 dígitos móvil chileno (9xxxxxxxx) |
| `nacionalidad` | text | 45× `Chileno`, 5× otras latinoamericanas creíbles |
| `avatar_url` | text | `NULL` — luego: `avatars/{auth_user_id}.jpg` |

### 2.2 Intereses (`usuario_intereses`)

- **3 a 5 intereses** por usuario.
- Solo `slug` existentes en catálogo (`running`, `yoga`, `fotografia`, etc.).
- Deben **correlacionar** con comunidades y eventos a los que pertenece (ej.: usuario en comunidad de ciclismo → intereses `ciclismo`, `senderismo`).

### 2.3 Perfiles variados (para exploración)

| Archetype | Cantidad | Intereses típicos | Rol en demo |
|-----------|----------|-------------------|-------------|
| Emprendedor tech | 8 | emprendimiento, networking, videojuegos | Organiza meetups |
| Deportista outdoor | 8 | running, ciclismo, senderismo | Eventos deportivos |
| Arte y cultura | 8 | fotografia, pintura, teatro, cine | Comunidades creativas |
| Gastronomía | 6 | gastronomia, cafeteria, enologia | Eventos food |
| Bienestar | 6 | yoga, meditacion | Comunidades wellness |
| Gaming / social | 6 | gaming, trivia, karaoke | Eventos indoor |
| Estudiante / idiomas | 4 | idiomas, lectura, debate | Talleres |
| Voluntariado | 4 | voluntariado, mascotas | Eventos sociales |

---

## 3. Comunidad (50 registros)

### 3.1 Campos

| Campo | Reglas |
|-------|--------|
| `nombre` | Único, 3–60 chars, español, sin genéricos tipo “Comunidad 1” |
| `descripcion` | 120–280 chars, tono invitador, menciona actividad y zona si aplica |
| `privacidad` | 44× `PUBLICA`, 6× `PRIVADA` |
| `estado` | 45× `ACTIVA`, 3× `PENDIENTE`, 2× `BLOQUEADA` |
| `usuario_id_usuario` | Creador = uno de los 50 usuarios (distribuir, no solo admin) |
| `banner_url` | `NULL` — luego: `communities/{id_comunidad}.jpg` |

### 3.2 Intereses (`comunidad_intereses`)

- **2 a 4 slugs** por comunidad, alineados al nombre/tema.
- Ejemplo: “Runners Costanera” → `running`, `atletismo`.

### 3.3 Miembros (`miembro_comunidad`)

| Rol | Cantidad por comunidad |
|-----|------------------------|
| `LIDER` | 1 (el creador) |
| `MIEMBRO` | 8–25 miembros aleatorios de los 50 usuarios |

Reglas:

- Cada usuario pertenece a **2–6 comunidades** (promedio ~4).
- Comunidades `PRIVADA`: solo miembros explícitos (5–12 personas).
- Comunidades `PENDIENTE`: solo creador + 0–2 miembros.

### 3.4 Nombres sugeridos (temas, no copiar literal todos)

Mezclar estilo local + temático:

- “Santiago Run Club”, “Viña Fotografía Urbana”, “Conce Tech Meetups”, “Temuco Senderismo Sur”, “Talca Café y Lectura”, “Gamers del Bio Bío”, “Yoga en la Costanera”, “Emprendedores Ñuñoa”, etc.

---

## 4. Evento (50 registros)

### 4.1 Campos

| Campo | Reglas |
|-------|--------|
| `nombre` | Corto interno (40 chars max) |
| `titulo` | Título visible, atractivo |
| `descripcion` | 150–400 chars, incluye qué llevar, nivel, público objetivo |
| `ubicacion_direccion` | Nombre del lugar + comuna (texto humano) |
| `direccion` | Calle y número reales o verosímiles **de esa comuna** |
| `comuna_id_comuna` | FK coherente con dirección |
| `latitud` / `longitud` | Coordenadas reales aproximadas del punto (Google Maps / OSM) |
| `fecha_realizacion` | Entre **now + 2 días** y **now + 90 días**; mezclar mañana/tarde/noche |
| `cupos_max` | 8–120 según tipo (yoga 15, fútbol 22, festival 100) |
| `edad_min` / `edad_max` | Opcional; usar en ~20% eventos (ej. +18, 16–35) |
| `estado` | 46× `ACTIVO`, 2× `CANCELADO`, 2× `FINALIZADO` (fechas pasadas) |
| `es_privado` | 40× false, 10× true (requieren solicitud) |
| `whatsapp_link` | 60% con link `https://chat.whatsapp.com/INVITE_CODE_DEMO` |
| `cover_url` | `NULL` — luego: `events/{id_evento}.jpg` |
| `usuario_id_usuario` | Organizador ∈ comunidad vinculada |
| `comunidad_id_comunidad` | FK; evento temáticamente ligado a esa comunidad |

### 4.2 Coherencia evento ↔ comuna (ejemplos reales)

| Comuna | Lugar / referencia | lat aprox | lng aprox |
|--------|-------------------|-----------|-----------|
| Providencia | Parque Bustamante | -33.441 | -70.632 |
| Providencia | Mall Costanera Center (meetup) | -33.417 | -70.606 |
| Las Condes | Parque Araucano | -33.401 | -70.578 |
| Santiago | Plaza de Armas | -33.437 | -70.650 |
| Ñuñoa | Estadio Nacional (perímetro) | -33.464 | -70.610 |
| Viña del Mar | Reloj de Flores | -33.024 | -71.551 |
| Concepción | Universidad de Concepción (campus) | -36.828 | -73.032 |
| Temuco | Plaza Aníbal Pinto | -38.736 | -72.587 |
| La Serena | Faro Monumental | -29.902 | -71.252 |
| Valdivia | Feria Fluvial | -39.814 | -73.245 |

**Nunca** poner “Parque Forestal” (Santiago/RM) con comuna Concepción.

### 4.3 Participantes (`participantes_evento`)

- **30–40 eventos** con participantes.
- Por evento: 3–15 inscripciones de otros usuarios.
- `estado_solicitud`: en eventos públicos mayoría `ACEPTADO`; en privados mezcla `PENDIENTE` / `ACEPTADO` / `RECHAZADO`.

---

## 5. Publicación (100 registros)

### 5.1 Campos

| Campo | Reglas |
|-------|--------|
| `titulo` | 5–80 chars; puede ser NULL en ~15% |
| `contenido` | 80–500 chars; tono conversacional chileno neutro |
| `fecha_publicacion` | Distribuida en últimos **45 días** (más densidad en últimos 7) |
| `usuario_id_usuario` | Autor |
| `comunidades_id_comunidad` | Comunidad donde publica; usuario **debe ser miembro** |
| `url_media` | 35× `NULL`, 65× placeholder `posts/{id_post}.jpg` (id asignado post-insert o secuencia) |

### 5.2 Distribución entre usuarios

| Tipo de usuario | Posts |
|-----------------|-------|
| 10 usuarios muy activos | 4 posts c/u → 40 |
| 25 usuarios moderados | 2 posts c/u → 50 |
| 15 usuarios ocasionales | 0–1 post → 10 |
| **Total** | **100** |

### 5.3 Tipos de contenido (variar)

- Anuncio de evento propio
- Resumen post-encuentro (“ayer corrimos 10k…”)
- Pregunta a la comunidad
- Recomendación (café, ruta, libro)
- Foto pendiente (“subiré fotos pronto”) — ideal sin `url_media` aún

---

## 6. Interacciones sociales (recomendado para demo rico)

### 6.1 Seguidores (`seguidores`)

- **80–120 relaciones** totales.
- Cada usuario: 2–12 seguidores, 2–12 seguidos.
- Sin auto-seguir; grafo plausible (usuarios de misma región/comunidad se siguen más).

### 6.2 Comentarios (`comentario`)

- **40–60 comentarios** en ~35 publicaciones distintas.
- 1–3 comentarios por post.
- Autor ≠ autor del post en 90% casos.

### 6.3 Likes (`reacciones_post`)

- **120–180 likes** totales.
- 50–70 publicaciones con al menos 1 like.
- `tipo_reaccion`: `LIKE`.

### 6.4 Notificaciones

**No insertar manualmente** en la mayoría de casos: los triggers de `loop_schema.sql` generan notificaciones al crear likes/comentarios/participaciones. Si se insertan likes/comentarios en seed, el inbox se poblará solo.

---

## 7. Placeholders de imágenes (carga manual posterior)

Convención Storage (buckets existentes: `avatars`, `events`, `posts`, `communities`):

| Bucket | Patrón | Cantidad esperada |
|--------|--------|-------------------|
| avatars | `{auth_user_id}.jpg` | 50 |
| communities | `{id_comunidad}.jpg` | 50 |
| events | `{id_evento}.jpg` | 50 |
| posts | `{id_post}.jpg` | ~65 |

Tras subir fotos, ejecutar UPDATE masivo o regenerar seed con URLs:

`{SUPABASE_URL}/storage/v1/object/public/avatars/{uuid}.jpg`

---

## 8. Orden de inserción SQL

```
1. auth.users + auth.identities
2. public.usuario
3. public.roles_sistema (admin)
4. public.usuario_intereses
5. public.comunidades
6. public.comunidad_intereses
7. public.miembro_comunidad
8. public.evento
9. public.participantes_evento
10. public.publicaciones
11. public.comentario
12. public.reacciones_post
13. public.seguidores
```

Limpieza previa (re-ejecutable): borrar en orden inverso filtrando `email LIKE '%@loop.cl'` y nombres de comunidades demo, o truncar tablas dependientes.

---

## 9. Formato de entrega recomendado

Para otra IA o importación, generar **5 CSV** + **1 SQL**:

| Archivo | Filas | Columnas clave |
|---------|-------|----------------|
| `demo_usuarios.csv` | 50 | uuid, email, password, username, nombres, apellidos, fecha_nacimiento, genero, comuna_nombre, region_nombre, telefono, rol_user, estado_cuenta, rut_opcional, intereses_slugs |
| `demo_comunidades.csv` | 50 | nombre, descripcion, privacidad, estado, creador_email, intereses_slugs |
| `demo_miembros.csv` | ~400 | comunidad_nombre, email_usuario, rol |
| `demo_eventos.csv` | 50 | titulo, descripcion, comuna_nombre, region_nombre, direccion, ubicacion_direccion, lat, lng, fecha_iso, cupos, es_privado, estado, comunidad_nombre, organizador_email |
| `demo_publicaciones.csv` | 100 | titulo, contenido, autor_email, comunidad_nombre, fecha_iso, tiene_imagen |
| `loop_seed_demo_extended.sql` | — | Script PL/pgSQL que lee los CSV vía `\copy` o valores embebidos |

---

## 10. Checklist de validación antes de ejecutar

- [ ] Ningún evento tiene comuna incompatible con su dirección
- [ ] Todo `intereses_slugs` existe en catálogo
- [ ] Todo miembro de comunidad es usuario existente
- [ ] Toda publicación: autor es miembro de la comunidad indicada
- [ ] Emails y usernames únicos
- [ ] Fechas de eventos futuros en zona `America/Santiago`
- [ ] 10 eventos privados tienen solicitudes pendientes para probar UI
- [ ] Admin y moderador pueden acceder al panel

---

## 11. ¿Quién lo genera?

Este documento es suficiente para que **otra IA** produzca los CSV/SQL.

**Cursor puede generarlo** en una siguiente iteración: salida esperada `docs/sql/loop_seed_demo_extended.sql` + CSV en `docs/demo_data/`, y script `scripts/seed-demo-extended.ps1` que reemplace o complemente `seed-demo.ps1`.

---

## 12. Resumen de volúmenes

| Entidad | Cantidad |
|---------|----------|
| Usuarios | 50 |
| Comunidades | 50 |
| Membresías | ~400 |
| Eventos | 50 |
| Participaciones evento | ~350 |
| Publicaciones | 100 |
| Comentarios | ~50 |
| Likes | ~150 |
| Seguidores | ~100 |
| Intereses usuario | ~200 |
| Intereses comunidad | ~150 |

# Documentación de vistas — Fase inicio de sesión (LOOP)

Documento vivo para alinear diseño y comportamiento **antes** de implementar pantallas en Flutter.  
Referencias visuales guardadas en el workspace:

- Onboarding / login / registro: `assets/c__Users_Franco_AppData_Roaming_Cursor_User_workspaceStorage_8bb63dac292951eba300d35f21b24772_images_figma_loop__inicio__registro-d6d13d8b-6a31-48b4-a5b0-00de326c4759.png` (ruta bajo el proyecto Cursor; copiar a `eventosloop/docs/references/` si se desea versionar en git).
- Recuperación de contraseña: `assets/c__Users_Franco_AppData_Roaming_Cursor_User_workspaceStorage_8bb63dac292951eba300d35f21b24772_images_recuperacion_de_password-488fb00d-2fee-40d6-9615-b1c6b3ec03c4.png`.

---

## 1. Lenguaje visual común (borrador)

| Elemento | Descripción (según mockups) |
|----------|-----------------------------|
| Fondo | Degradado azul muy claro → blanco; patrones orgánicos suaves (splash y login). |
| Texto principal | Azul oscuro, sans-serif moderna. |
| Acento / CTA | Azul vivo; botones anchos, esquinas redondeadas; en flujo de recuperación, gradiente horizontal azul en botones. |
| Tarjetas | Contenedor blanco flotante con bordes redondeados sobre el fondo (login, parte de nueva contraseña). |
| Campos | Fondo azul muy tenue en el área de input; labels en mayúsculas pequeñas donde aplica. |
| Iconografía | Línea fina, minimalista. |

**Pendiente de cerrar antes de codificar tokens en Flutter:** valores hex/RGB exactos, familia de fuente, radios (8/12/16), elevación/sombras de cards.

---

## 2. Hoja de ruta de navegación (alto nivel)

```text
[Splash] → [Login]
            ├→ [Sign up] (enlace desde login)
            ├→ [Registro / Create Account]
            └→ [Olvidé contraseña] → [Verificar código] → [Nueva contraseña] → volver a [Login]
```

Flujos sociales (Google / Apple) desde login: definir si el registro también los ofrece o solo login.

---

## 3. Vista por vista

### 3.1 Splash — “LOOP”

| Campo | Detalle |
|-------|---------|
| **Objetivo** | Marca de arranque mientras la app inicializa (assets, sesión, configuración). |
| **Contenido** | Logo tipográfico **LOOP** (azul oscuro, centrado). Subtítulo: *CONÉCTATE Y DESCUBRE*. |
| **Feedback** | Barra de progreso horizontal (relleno mayoritariamente azul). Texto bajo la barra: *INITIALIZING SPACE* + puntos suspensivos. |
| **Navegación automática** | Al terminar carga / timeout → siguiente pantalla (normalmente Login o Home si hay sesión). **Definir:** duración mínima, condición de salto a Home. |
| **Operación técnica** | Precarga de fuentes/imágenes; comprobación de token de sesión; posible remoto config. |
| **Pendiente diseño** | ¿Texto en inglés o español para “INITIALIZING SPACE”? ¿Animación del logo además de la barra? |

---

### 3.2 Login / Sign In — “Bienvenido”

| Campo | Detalle |
|-------|---------|
| **Objetivo** | Autenticar usuario existente. |
| **Cabecera** | Logo LOOP centrado arriba. |
| **Contenedor** | Card blanca con esquinas redondeadas. Título: **Bienvenido**. |
| **Campos** | **EMAIL ADDRESS** — placeholder `name@example.com`. **PASSWORD** — enlace *Forgot password?* a la derecha del label o fila; icono ojo para mostrar/ocultar. |
| **CTA principal** | Botón **Sign In** (azul). |
| **Alternativas** | Separador *OR CONTINUE WITH*; botones **Google** y **Apple** con logos. |
| **Pie** | *Don't have an account?* **Sign up** (enlace a registro). |
| **Validación** | Email formato; contraseña no vacía; mensajes de error inline o snackbar (**definir**). |
| **Operación** | Submit → API login; errores 401/429; guardar sesión según estrategia (token, refresh). OAuth: deep link / SDK nativo. |
| **Pendiente diseño** | Mezcla ES/EN en copy: unificar idioma o i18n desde el día 1. Comportamiento del enlace “Forgot password?” (navegación a flujo sección 3.4–3.6). |

---

### 3.3 Registro — “Create Account”

| Campo | Detalle |
|-------|---------|
| **Objetivo** | Alta de cuenta con datos personales, ubicación y credenciales. |
| **App bar** | Atrás; título **Create Account**; logo LOOP a la derecha. |
| **Intro** | **Join the Community** + subtítulo sobre “era de conexión digital”, tono editorial. |
| **Sección 1 — Personal** (icono persona azul) | Nombres, Apellidos, Nombre de usuario/Alias (campo con icono usuario). |
| **Sección 2 — Ubicación** (icono pin) | Dirección, Comuna, **Región** (dropdown), Código postal. |
| **Sección 3 — Seguridad** (icono candado morado) | Correo electrónico, Contraseña alfanumérica (toggle visibilidad). Texto de ayuda: mínimo 8 caracteres, letras y números; indicación con checkbox pequeño (¿solo informativo o validación visual?). |
| **Legal** | Checkbox: acepto **Terms of Service** y **Privacy Policy** (enlaces). |
| **CTA** | **Create Account** con icono flecha a la derecha. |
| **Pie** | Iconos/enlaces **Help** y **Support**. |
| **Validación** | Campos obligatorios; formato email; contraseña según reglas; región seleccionada; checkbox legal obligatorio. |
| **Operación** | POST registro; posible email de verificación (**definir** si la cuenta queda activa al instante). Scroll largo: `SingleChildScrollView` + considerar teclado (`resizeToAvoidBottomInset`). |
| **Pendiente diseño** | Lista de regiones/comunas (Chile u otro país). Si alias es único, feedback “no disponible” en tiempo real (**definir**). |

---

### 3.4 Olvidé contraseña — “Forgot Password”

| Campo | Detalle |
|-------|---------|
| **Objetivo** | Solicitar código de recuperación al email. |
| **Marca** | Nombre oficial de la app: **LOOP**. (En el mockup de recuperación aparecía por error “L33P”; en implementación usar siempre **LOOP** en app bar y pies.) |
| **App bar** | Atrás + título centrado **LOOP**. |
| **Hero** | Icono circular: candado con flecha circular (refresh). |
| **Título / subtítulo** | **Forgot Password** / *Enter your email to receive a recovery code*. |
| **Campo** | Label **EMAIL ADDRESS**; input con icono mail; placeholder `name@example.com`. |
| **CTA** | **Send Code >** (gradiente). |
| **Enlace** | *Remember your password?* **Login**. |
| **Card informativa** | Escudo + texto **Secure Account Recovery** — código expira en **10 minutos**. |
| **Footer** | *© 2024 LOOP ECOSYSTEM* (**actualizar año** si se mantiene). |
| **Operación** | POST “forgot password”; rate limiting; no revelar si el email existe (opción seguridad UX). Navegación → pantalla verificación con email en argumentos o estado. |
| **Pendiente diseño** | Copy en un solo idioma; si el código se envía por SMS en el futuro, esta pantalla podría bifurcar (**fuera de MVP**). |

---

### 3.5 Verificación de identidad — “Verify Identity”

| Campo | Detalle |
|-------|---------|
| **Objetivo** | Introducir código OTP de 6 dígitos enviado por email. |
| **App bar** | Igual que 3.4 (atrás + **LOOP** centrado). |
| **Hero** | Escudo en recuadro blanco suave. |
| **Título / subtítulo** | **Verify Identity** / *Enter the 6-digit code sent to your email*. |
| **Input OTP** | 6 cajas individuales redondeadas; placeholders como punto. |
| **CTA** | **Verify >**. |
| **Enlace** | *Didn't receive the code?* **Resend code** (cooldown **definir**, p. ej. 60 s). |
| **Footer** | *SECURE VERIFICATION* con icono escudo. |
| **Operación** | Verificar código con backend; intentos máximos; al éxito → **New Password**; al fallo → mensaje claro. Auto-avance entre campos OTP y pegado desde portapapeles (**definir**). |
| **Pendiente diseño** | Mostrar enmascarado el email destino (*a***@gmail.com) para reducir errores. |

---

### 3.6 Nueva contraseña — “New Password”

| Campo | Detalle |
|-------|---------|
| **Objetivo** | Establecer contraseña nueva tras verificación. |
| **App bar** | Igual que flujo anterior. |
| **Gráfico** | Imagen/banda horizontal estilo “luz digital” (clave). **Definir** asset final vs placeholder. |
| **Título / subtítulo** | **New Password** / *Create a strong password for your account*. |
| **Card** | **New Password** (input + ojo). **Confirm Password** (input + ojo tachado según estado). |
| **Requisitos** | Lista con checks: mínimo 8 caracteres; incluir números y **símbolos** (**nota:** registro decía “letras y números” — alinear política global de contraseña). |
| **CTA** | **Reset Password**. |
| **Enlace** | **Back to Sign In** → stack limpio hasta Login. |
| **Operación** | POST reset con token de sesión de recuperación; invalidar código usado; forzar re-login. |
| **Pendiente diseño** | Indicador en vivo de fortaleza de contraseña; coincidencia confirmación en tiempo real. |

---

## 4. Decisiones transversales (checklist antes de Flutter)

- [x] **Marca en cabecera:** **LOOP** (corregido respecto al typo “L33P” del mockup de Figma).
- [ ] **Idioma:** español, inglés o ambos con locale.
- [ ] **Política de contraseña:** misma regla en registro, login y reset (longitud, números, símbolos).
- [ ] **OAuth:** solo login o también registro; flujo de cuenta existente vinculada a email.
- [ ] **Registro:** ¿verificación de email obligatoria antes de usar la app?
- [ ] **Recuperación:** expiración código (mockup: 10 min); reenvío; máximo de intentos.
- [ ] **Accesibilidad:** contraste de textos grises, tamaños táctiles, orden de foco en OTP.
- [ ] **Tokens de diseño:** exportar de Figma (o fijar manualmente) colores, tipografía, espaciado.

---

## 5. Próximo paso sugerido

Cuando cierres los ítems de la sección 4, este documento se puede actualizar con una columna “Decisión final” por fila y enlazar a issues o a `theme_data` / `AppColors` del repo Flutter.

---

## 6. Estado del repo Flutter (preparación)

- **Targets:** solo **Android** y **Web** (carpetas `android/`, `web/`); se quitaron `ios`, `windows`, `linux`, `macos` para reducir ruido.
- **Código:** `lib/main.dart` arranca `lib/app/loop_app.dart`; esqueleto en `lib/core/` y `lib/features/`; recursos en `assets/`.
- **Comandos y doctor:** ver `README.md` en la raíz del proyecto.

---

## 7. Nota MER recibida (usuario como entidad central)

Con las 3 capturas iniciales del MER y esta cuarta captura, se confirma que `usuario` actúa como entidad pivote para módulos sociales y de administración.

### Tablas conectadas directamente a `usuario` vistas en las capturas

- `comunidades`
- `intereses`
- `miembro_comunidad`
- `reporte_publicacion`
- `adm_log`
- `roles_sistema`
- `seguidores`
- `tienev2` (tabla puente de seguimiento)
- `publicaciones`
- `comentario`
- `reacciones_post`
- `evento`

### Impacto inmediato en arquitectura MVVC (Flutter)

- **Feature `auth`**: usa `usuario` como modelo raíz de sesión/perfil.
- **Feature `social`**: depende de `publicaciones`, `comentario`, `reacciones_post`, `seguidores`, `intereses`, `comunidades`.
- **Feature `events`**: `evento` ligado a `usuario` (creador) y a ubicación (`comuna`/`region`).
- **Feature `admin`**: `roles_sistema`, `reporte_publicacion`, `adm_log` para moderación/auditoría.

> Esta sección es de alineación funcional previa. Al recibir el MER final (idealmente completo o exportado), se deben cerrar tipos exactos, cardinalidades y reglas de negocio por tabla.

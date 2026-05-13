# LOOP (`eventosloop`)

App de eventos en Flutter. **Targets activos:** Android (móvil) y Web (p. ej. panel administración en navegador).

## Requisitos

- Flutter SDK en el PATH (`flutter doctor`).
- Android: Android Studio / SDK y, si pide el doctor, **cmdline-tools** y `flutter doctor --android-licenses`.
- Web: Chrome (u otro navegador compatible).

En Cursor/VS Code el proyecto incluye **`.vscode/`**: formato al guardar en Dart y extensión recomendada Dart-Code.

## Comandos útiles

```bash
cd eventosloop
flutter pub get
flutter analyze
```

- Ejecutar en **Android** (emulador o dispositivo): `flutter run`
- Ejecutar en **Web**: `flutter run -d chrome`
- APK de prueba: `flutter build apk --debug`

## Documentación de producto

Especificación de pantallas de la fase de inicio de sesión: `docs/ui-vistas-fase-inicio-sesion.md`.

## Estructura de `lib/` (inicial)

| Ruta | Uso previsto |
|------|----------------|
| `lib/app/` | `MaterialApp`, tema, enrutado global. |
| `lib/core/` | Constantes, utilidades, errores compartidos. |
| `lib/features/` | Funcionalidades por dominio (auth, eventos, …). |

Recursos estáticos: carpeta `assets/` (ya registrada en `pubspec.yaml`).

## Subir a GitHub

1. Crea el repositorio vacío en GitHub (sin README si ya tienes uno local).
2. En la carpeta del proyecto:

```bash
git add .
git commit -m "Proyecto inicial LOOP (Flutter: Android + Web)"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
git push -u origin main
```

`pubspec.lock` está incluido a propósito para que las dependencias coincidan en CI y entre máquinas. No subas claves: usa `.env` (ignorado en `.gitignore`) y opcionalmente un `.env.example` sin valores reales.

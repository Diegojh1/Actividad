# Gestión de Datos - Flutter (Material 3)

Aplicación móvil Flutter para gestionar datos localmente con una experiencia moderna (Material 3), tema claro/oscuro persistente y navegación con rutas nombradas. Incluye autenticación básica, CRUD local y pantalla de ajustes.

## Características

- Autenticación simple con registro e inicio de sesión (almacenado localmente)
- Tema claro/oscuro con persistencia usando `SharedPreferences`
- Navegación con rutas: `/login`, `/home`, `/settings`, `/saved`
- Gestión de datos local (crear, listar, editar y eliminar)
- UI modernizada con Material 3 y `ColorScheme.fromSeed`

## Estructura principal

- `lib/main.dart`: arranque de la app, tema y rutas
- `lib/theme_service.dart`: servicio para persistir `ThemeMode`
- `lib/auth_service.dart`: autenticación local con `SharedPreferences`
- `lib/data_service.dart`: CRUD local de datos (lista en JSON)
- `lib/home_screen.dart`: pantalla principal con acciones rápidas y FAB
- `lib/saved_data_screen.dart`: lista editable con `Dismissible`
- `lib/settings_screen.dart`: alternar modo oscuro y cerrar sesión

## Requisitos

- Flutter 3.22+ (SDK Dart 3.9+)
- Dispositivo/emulador iOS/Android o ejecución web/desktop habilitada

## Instalación y ejecución

```bash
flutter pub get
flutter run
```

Para seleccionar dispositivo:

```bash
flutter devices
flutter run -d <deviceId>
```

## Notas técnicas

- Persistencia local: `shared_preferences`
- Estilo: Material 3 con `useMaterial3: true`
- Edición en lista con diálogo; borrado por deslizamiento (`DismissDirection.endToStart`)

## Autor

Diego Hernandez

Si tienes sugerencias o deseas colaborar, ¡bienvenido! Abre un issue o envía un PR.

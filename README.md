# Gestor de Tareas - Flutter

Este es un gestor de tareas desarrollado con Flutter y Dart. La aplicación permite a los usuarios gestionar tareas de manera eficiente, establecer notificaciones, proteger los datos mediante autenticación local, y mucho más.

## Características

- **Gestión de tareas**: Crear, editar, eliminar y marcar tareas como completadas.
- **Autenticación local**: Protección de datos con autenticación biométrica y almacenamiento seguro de credenciales.
- **Notificaciones locales**: Recordatorios de tareas a través de notificaciones push.
- **Almacenamiento local**: Uso de `sqflite` para almacenar tareas de manera local en la base de datos del dispositivo.
- **Soporte de CSV**: Importación y exportación de tareas a archivos CSV.
- **Interfaz de usuario interactiva**: Uso de gráficos (con `fl_chart`) y una interfaz dinámica con carouseles para mejorar la experiencia de usuario.

## Requisitos

- **Flutter**: 3.27.1 o superior
- **Dart**: 3.6.0 o superior

## Dependencias

Este proyecto utiliza las siguientes dependencias:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  sqflite: ^2.4.1
  local_auth: ^2.3.0
  flutter_secure_storage: ^9.2.3
  intl: ^0.17.0
  flutter_local_notifications: ^18.0.1
  permission_handler: ^11.4.0
  csv: ^5.0.0
  open_file: ^3.3.2
  fl_chart: ^0.70.2
  clipboard: ^0.1.3
  carousel_slider: ^5.0.0
```

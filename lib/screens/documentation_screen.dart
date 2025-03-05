import 'package:flutter/material.dart';

class DocumentationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Elimina el botón de retroceso predeterminado
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            iconSize: 34, // Establece el tamaño del icono
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard('Bienvenida', '''
¡Bienvenido a la Aplicación de Gestión de Tareas! Esta aplicación está diseñada para ayudarte a organizar y gestionar tus tareas de manera eficiente. A continuación, encontrarás una guía paso a paso sobre cómo utilizar todas las funcionalidades de la aplicación.
'''),
            _buildSectionCard('Registro e Inicio de Sesión', '''
1. Registrarse:
- Abre la aplicación y pulsa en "Registrarse".
- Introduce tu nombre completo, correo electrónico y una contraseña segura.
- Pulsa en "Continuar".

2. Verificación:
- Recibirás un código de verificación en tu correo electrónico.
- Ingresa el código y pulsa en "Verificar".

3. Inicio de sesión:
- Ingresa tu correo electrónico y contraseña para iniciar sesión.
- También puedes activar el inicio de sesión con tu huella digital si tu dispositivo lo soporta.
- Pulsa en "Empezar" para ser dirigido a la pantalla principal de tareas.
'''),
            _buildSectionCard('Navegación Principal', '''
Al estar dentro de la app, verás la pantalla principal de la aplicación. Aquí podrás acceder a las principales funciones:
- **Inicio**: Muestra tu lista de tareas pendientes, completadas y tareas a vencer.
- **Tareas**: Accede a todas tus tareas organizadas por categorías y prioridades.
- **Informes**: Visualiza estadísticas de productividad y progreso.
- **Más**: Ajustes, perfil de usuario y opciones avanzadas.
'''),
            _buildSectionCard('Registrar una Tarea', '''
1. Pulsa en el botón "+" para agregar una nueva tarea.
2. Introduce la información de la tarea:
- **Título**: Descripción breve de la tarea.
- **Fecha de vencimiento**: Selecciona la fecha límite para completar la tarea.
- **Categoría**: Selecciona o crea una nueva categoría para organizar tu tarea.
- **Prioridad**: Asigna un nivel de prioridad (Baja, Media, Alta).
- **Descripción**: Agrega detalles adicionales sobre la tarea.
3. Pulsa en "Guardar tarea".
'''),
            _buildSectionCard('Editar una Tarea', '''
1. Accede a la sección "Tareas" desde el menú principal.
2. Pulsa en el ícono de lápiz al lado de la tarea que deseas editar.
3. Actualiza la información de la tarea:
- **Título**: Modifica el título de la tarea.
- **Fecha de vencimiento**: Ajusta la fecha de vencimiento si es necesario.
- **Categoría y Prioridad**: Cambia la categoría y/o prioridad.
- **Descripción**: Agrega o modifica los detalles de la tarea.
4. Pulsa en "Guardar cambios".
'''),
            _buildSectionCard('Eliminar una Tarea', '''
1. Accede a la sección "Tareas" desde el menú principal.
2. Pulsa en el ícono rojo de eliminación junto a la tarea que deseas eliminar.
- Aparecerá un cuadro de confirmación; confirma la eliminación de la tarea.
'''),
            _buildSectionCard('Registrar una Categoría', '''
1. Desde el menú principal, pulsa en "Gestionar categorías".
2. Pulsa en el ícono "+" para agregar una nueva categoría.
- Introduce el nombre de la categoría.
3. Pulsa en "Guardar".
'''),
            _buildSectionCard('Editar una Categoría', '''
1. Desde el menú principal, pulsa en "Gestionar categorías".
2. Pulsa en el ícono de lápiz junto a la categoría que deseas editar.
- Modifica el nombre de la categoría.
3. Pulsa en "Guardar".
'''),
            _buildSectionCard('Eliminar una Categoría', '''
1. Desde el menú principal, pulsa en "Gestionar categorías".
2. Pulsa en el ícono rojo para eliminar una categoría.
- Si la categoría tiene tareas asociadas, no podrás eliminarla.
- Se abrirá un cuadro de confirmación para proceder con la eliminación.
'''),
            _buildSectionCard('Informe de Productividad', '''
1. Desde el menú principal, pulsa en "Informe de productividad".
2. Aquí podrás ver tu rendimiento y productividad por:
- Tareas completadas.
- Tareas pendientes.
- Tareas vencidas.
3. Filtra por fecha personalizada o por prioridad para obtener un análisis más detallado.
'''),
            _buildSectionCard('Resumen de Tareas', '''
1. Desde el menú principal, pulsa en "Resumen de tareas".
2. Verás:
- Un gráfico de barras que representa tus tareas por categoría.
- El total de tareas pendientes y completadas.
'''),
            _buildSectionCard('Más Opciones', '''
1. Desde el menú principal, pulsa en "Más".
2. Aquí podrás:
- Modificar tu contraseña.
- Activar o desactivar el inicio de sesión con huella digital.
- Ver el historial de tareas completadas.
- Cerrar sesión.
'''),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

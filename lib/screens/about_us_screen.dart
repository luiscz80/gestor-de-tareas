import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            iconSize: 34,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 80,
                ),
                SizedBox(height: 0),
                Text(
                  'APP Gestor de Tareas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  'Versión 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildDescription(),
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Text(
                          'Síguenos en:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContactIconButton(Icons.facebook, null),
                            _buildContactIconButton(Icons.tiktok, null),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      _appDescription,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget _buildContactIconButton(IconData icon, VoidCallback? onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 40,
        color: Colors.blue,
      ),
    );
  }
}

const String _appDescription = '''
La aplicación de gestión de tareas es una herramienta esencial para aquellos que buscan optimizar su productividad y mantenerse organizados de manera eficiente. Diseñada con una interfaz limpia y fácil de usar, esta aplicación proporciona una solución integral para gestionar tareas diarias, proyectos y objetivos, permitiendo a los usuarios llevar un seguimiento detallado de su progreso.

**Características Principales:**

- **Gestión de Tareas:** Permite a los usuarios agregar, editar y eliminar tareas, organizándolas por categorías, prioridades y fechas de vencimiento. La interfaz intuitiva facilita la administración de tareas en cualquier momento.
  
- **Recordatorios y Notificaciones:** Configura alertas para asegurarte de que no se te pase ninguna tarea importante. Recibe notificaciones oportunas antes de las fechas límite para mantenerte enfocado y a tiempo.
  
- **Visualización de Tareas:** Ofrece opciones de visualización flexibles, ya sea en formato lista o en modo de cuadrícula. Además, puedes filtrar y ordenar las tareas según su estado (completadas o pendientes), prioridad o fecha de vencimiento.
   
- **Estadísticas de Productividad:** Visualiza tu rendimiento a través de gráficos interactivos, que muestran el progreso de tus tareas y proyectos, ayudándote a mejorar la eficiencia y a identificar áreas de mejora.
  
- **Personalización:** Permite personalizar la aplicación según las preferencias del usuario, como el tema claro o oscuro, el orden de las tareas, y las categorías personalizadas.

**Beneficios:**

- Mejora en la organización y planificación de tareas diarias y proyectos.
- Aumento en la productividad mediante recordatorios y seguimiento visual.
- Simplificación del proceso de priorización y ejecución de tareas.
- Acceso rápido y seguro a tus tareas desde cualquier dispositivo.
- Toma de decisiones más informada para cumplir objetivos personales y profesionales.

**Conclusión:**

La aplicación de gestión de tareas es el aliado perfecto para quienes desean tomar el control de su tiempo y mantener una organización eficiente. Con su interfaz profesional y características avanzadas, esta aplicación no solo mejora la productividad, sino que también facilita la planificación y ejecución de proyectos a largo plazo, permitiendo a los usuarios alcanzar sus objetivos de manera efectiva y sin estrés.
''';

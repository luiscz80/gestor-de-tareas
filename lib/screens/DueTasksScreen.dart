import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/utils/notification_service.dart';
import 'package:tareas/widgets/formatted_date.dart';
import '../providers/tasks_provider.dart';

class DueTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 34,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Tareas Vencidas',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TasksProvider>(
          builder: (context, taskProvider, child) {
            // Filtramos solo las tareas vencidas
            final dueTasks = taskProvider.tasks
                .where((task) =>
                    task.date.isBefore(DateTime.now()) &&
                    task.status != 'Completado')
                .toList();

            return dueTasks.isEmpty
                ? Center(
                    child: Text(
                      'No hay tareas vencidas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: dueTasks.length,
                    itemBuilder: (context, index) {
                      final task = dueTasks[index];

                      _checkTaskExpiration(task);

                      return Card(
                        elevation: 6,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Color.fromARGB(255, 209, 66, 56),
                            width: 1,
                          ),
                        ),
                        color: Colors.red.shade50,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.warning,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.redAccent,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Text(
                                task.description,
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      task.priority,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor:
                                        _getPriorityColor(task.priority),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha y Hora Límite: ',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                  FormattedDate(
                                    dateTime: task.date,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '¡Esta tarea ha vencido!',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  bool _checkTaskExpiration(task) {
    DateTime now = DateTime.now();
    bool isExpired = task.date.isBefore(now);

    if (isExpired) {
      NotificationService.showNotification(
          'Tarea vencida', 'La tarea "${task.title}" ha vencido.');
    }

    return isExpired;
  }
}

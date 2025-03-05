import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/widgets/formatted_date.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import '../providers/tasks_provider.dart';

class PendingTasksScreen extends StatelessWidget {
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
                    'Tareas Pendientes',
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
            final pendingTasks = taskProvider.tasks
                .where((task) =>
                    task.status != 'Completado' &&
                    task.date.isAfter(DateTime.now()))
                .toList();

            return pendingTasks.isEmpty
                ? Center(
                    child: Text(
                      'No hay tareas pendientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: pendingTasks.length,
                    itemBuilder: (context, index) {
                      final task = pendingTasks.reversed.toList()[index];

                      return Card(
                        elevation: 6,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Color.fromARGB(255, 31, 97, 151),
                            width: 2,
                          ),
                        ),
                        color: task.date.isBefore(DateTime.now())
                            ? Colors.red.shade50
                            : Colors.grey.shade50,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: task.date.isBefore(DateTime.now())
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                            child: Icon(
                              task.date.isBefore(DateTime.now())
                                  ? Icons.warning
                                  : Icons.pending_actions,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: task.date.isBefore(DateTime.now())
                                  ? Colors.redAccent
                                  : Colors.black87,
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
                                    'Fecha y Hora Límite:',
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
                                  if (task.date.isBefore(DateTime
                                      .now())) // Muestra este mensaje si la tarea está vencida
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
                          trailing: IconButton(
                            icon: Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {
                              _showCompletionDialog(
                                  context, task.title, task.id!, taskProvider);
                            },
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

  void _showCompletionDialog(BuildContext context, String taskTitle, int taskId,
      TasksProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '¿Estás seguro de que deseas marcar la tarea "',
                  style: TextStyle(color: Colors.black54),
                ),
                TextSpan(
                  text: taskTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: '" como completado?',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _markAsCompleted(context, taskTitle, taskId, taskProvider);
              },
              child: Text('Sí', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _markAsCompleted(BuildContext context, String taskTitle, int taskId,
      TasksProvider taskProvider) {
    taskProvider.markTaskAsCompleted(taskId).then((_) {
      showCustomSnackBar(context, 'Tarea "$taskTitle" completada con éxito.');
    });
  }
}

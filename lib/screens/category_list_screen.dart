import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categories_provider.dart';
import '../providers/tasks_provider.dart';
import '../screens/edit_category_dialog.dart';
import 'edit_task_screen.dart';
import '../screens/add_category_dialog.dart';

class CategoryScreen extends StatelessWidget {
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
                    'Mis Categorías',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Consumer<CategoriesProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.categories.isEmpty) {
            return Center(
              child: Text(
                'Aún no hay categorías',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final categories = categoryProvider.categories.reversed.toList();
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionTile(
                    key: PageStorageKey(category.id),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}. ${category.name.length > 10 ? category.name.substring(0, 10) + '...' : category.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Color.fromARGB(255, 6, 206, 178),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      EditCategoryDialog(category: category),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                final tasks = Provider.of<TasksProvider>(
                                        context,
                                        listen: false)
                                    .tasks;
                                final hasTasks = await categoryProvider
                                    .hasTasksInCategory(category.id!, tasks);
                                if (hasTasks) {
                                  showCustomSnackBar(context,
                                      'No se puede eliminar esta categoría, porque tiene tareas vinculados.');
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Eliminar Categoría',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      content: Text(
                                          '¿Estás seguro de que deseas eliminar esta categoría?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            categoryProvider
                                                .deleteCategory(category.id!);
                                            Navigator.of(context).pop();
                                            showCustomSnackBar(context,
                                                'La categoria ha sido eliminado con éxito.');
                                          },
                                          child: Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Column(
                        children: Provider.of<TasksProvider>(context)
                            .tasks
                            .where((task) => task.categoryId == category.id)
                            .map((task) {
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    task.title.length > 16
                                        ? '${task.title.substring(0, 16)}...'
                                        : task.title,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 600),
                                            pageBuilder: (_, __, ___) =>
                                                EditTaskScreen(
                                              task: task,
                                            ),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(0, 1),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Eliminar Tarea',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            content: Text(
                                                '¿Estás seguro de que deseas eliminar este tarea?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Provider.of<TasksProvider>(
                                                          context,
                                                          listen: false)
                                                      .deleteTask(task.id!);
                                                },
                                                child: Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddCategoryDialog(),
          );
        },
        child: Icon(Icons.add),
        heroTag: 'addCategory',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

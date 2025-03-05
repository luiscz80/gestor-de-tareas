import 'package:tareas/models/categories.dart';
import 'package:tareas/providers/categories_provider.dart';
import 'package:tareas/widgets/formatted_date.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import '../models/task.dart';
import 'edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController();
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  void _unfocusSearchField() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<TasksProvider, CategoriesProvider>(
        builder: (context, taskViewModel, categoriesProvider, child) {
          List<Task> displayedTasks = taskViewModel.tasks
              .where((task) =>
                  task.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  task.id.toString().contains(searchQuery.toLowerCase()) ||
                  task.priority
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  task.status.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          if (selectedCategory != null) {
            displayedTasks = displayedTasks
                .where((task) => task.categoryId == selectedCategory!.id)
                .toList();
          }

          if (taskViewModel.tasks.isEmpty) {
            return Center(
              child: Text(
                'Aún no hay registro de tareas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Tareas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${taskViewModel.tasks.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            hintText: 'Buscar por título, prioridad y estado',
                            hintStyle: TextStyle(fontSize: 13),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 6, 206, 178),
                            ),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        searchQuery = '';
                                      });
                                      _unfocusSearchField();
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0)),
                            ),
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0)),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 50,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Filtrar por categorías',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 6, 206, 178),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedCategory = null;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: selectedCategory == null
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 8.0),
                                              child: Text(
                                                'Todas las tareas',
                                                style: TextStyle(
                                                  color:
                                                      selectedCategory == null
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          ...categoriesProvider
                                              .categories.reversed
                                              .map((category) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory = category;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: selectedCategory ==
                                                          category
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 8.0),
                                                child: Text(
                                                  category.name,
                                                  style: TextStyle(
                                                    color: selectedCategory ==
                                                            category
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.filter_list,
                            color: Color.fromARGB(255, 6, 206, 178)),
                      ),
                    ),
                  ],
                ),
                if ((searchQuery.isNotEmpty && displayedTasks.isEmpty) ||
                    (selectedCategory != null && displayedTasks.isEmpty))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Text(
                      'No se encontraron resultados',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 0),
                    child: ListView.builder(
                      itemCount: displayedTasks.length,
                      itemBuilder: (context, index) {
                        final int reversedIndex =
                            displayedTasks.length - 1 - index;
                        final Task task = displayedTasks[reversedIndex];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 8.0),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Center(
                                    child: Text(
                                      '${task.title.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  content: Container(
                                    width: double.maxFinite,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ESTADO: ${task.status.toUpperCase()}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: task.status == 'Pendiente'
                                                  ? Colors.blue
                                                  : Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _unfocusSearchField();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 1,
                                        ),
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  task.title.length > 16
                                                      ? '${task.title.substring(0, 16).toUpperCase()}...'
                                                      : task.title
                                                          .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: _getPriorityColor(
                                                          task.priority)
                                                      .withOpacity(0.15),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      _getPriorityIcon(
                                                          task.priority),
                                                      size: 14,
                                                      color: _getPriorityColor(
                                                          task.priority),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'Prioridad: ${task.priority.toUpperCase()}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            _getPriorityColor(
                                                                task.priority),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Descripción: ${task.description}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Categoría: ${Provider.of<CategoriesProvider>(context).categories.firstWhere(
                                                  (category) =>
                                                      category.id ==
                                                      task.categoryId,
                                                  orElse: () => Category(
                                                      id: -1,
                                                      name: 'No definida'),
                                                ).name}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Fecha y Hora Límite:',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                              FormattedDate(
                                                dateTime: task.date,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: _getTaskBackColor(
                                                  task.status),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                _getTaskStatusIcon(task.status),
                                                size: 30,
                                                color: _getTaskStatusColor(
                                                    task.status),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                color: Color.fromARGB(
                                                    255, 6, 206, 178),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  600),
                                                      pageBuilder:
                                                          (_, __, ___) =>
                                                              EditTaskScreen(
                                                        task: task,
                                                      ),
                                                      transitionsBuilder: (_,
                                                          animation,
                                                          __,
                                                          child) {
                                                        return SlideTransition(
                                                          position:
                                                              Tween<Offset>(
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
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'Eliminar Tarea',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: RichText(
                                                        text: TextSpan(
                                                          text:
                                                              '¿Estás seguro de que deseas eliminar la tarea: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  '${task.title.toUpperCase()}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            TextSpan(text: '?'),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            _unfocusSearchField();
                                                          },
                                                          child:
                                                              Text('Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            taskViewModel
                                                                .deleteTask(
                                                                    task.id!);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            _unfocusSearchField();
                                                          },
                                                          child:
                                                              Text('Eliminar'),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Consumer<TasksProvider>(
        builder: (context, taskViewModel, child) {
          if (taskViewModel.tasks.length > 3) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDeleteConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Eliminar tareas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Baja':
        return Colors.green;
      case 'Media':
        return Colors.orange;
      case 'Alta':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'Baja':
        return Icons.check_circle;
      case 'Media':
        return Icons.priority_high;
      case 'Alta':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  IconData _getTaskStatusIcon(String status) {
    switch (status) {
      case 'Pendiente':
        return Icons.hourglass_empty;
      case 'Completado':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  Color _getTaskStatusColor(String status) {
    switch (status) {
      case 'Pendiente':
        return Colors.blue;
      case 'Completado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getTaskBackColor(String status) {
    switch (status) {
      case 'Pendiente':
        return const Color.fromARGB(255, 201, 219, 235);
      case 'Completado':
        return const Color.fromARGB(255, 193, 236, 208);
      default:
        return Colors.grey;
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Eliminar todas las Tareas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que deseas eliminar todas las Tareas?'),
              Text(
                'No podrá revertir esta acción.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _unfocusSearchField();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TasksProvider>(context, listen: false)
                    .deleteAllTasks();
                Navigator.pop(dialogContext);
                _unfocusSearchField();
                showCustomSnackBar(
                    context, 'Todas las tareas han sido eliminados con éxito.');
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

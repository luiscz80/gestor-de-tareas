import 'package:tareas/models/categories.dart';
import 'package:tareas/providers/categories_provider.dart';
import 'package:tareas/screens/add_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late String taskTitle;
  late String taskDescription;
  late String taskPriority;
  late String taskStatus;
  Category? selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    taskTitle = widget.task.title;
    taskDescription = widget.task.description;
    taskPriority = widget.task.priority;
    taskStatus = widget.task.status;

    selectedCategory = Provider.of<CategoriesProvider>(context, listen: false)
        .categories
        .firstWhere((category) => category.id == widget.task.categoryId);
    _selectedDate = widget.task.date;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _unfocusSearchField() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TasksProvider>(context);
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
                    'Editar tarea',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text('Título de tarea'),
            TextFormField(
              initialValue: taskTitle,
              onChanged: (value) {
                taskTitle = value;
              },
            ),
            SizedBox(height: 16),
            Text('Descripción de tarea'),
            TextFormField(
              initialValue: taskDescription,
              onChanged: (value) {
                taskDescription = value;
              },
            ),
            SizedBox(height: 16),
            DropdownButton<Category>(
              hint: Text(selectedCategory != null
                  ? selectedCategory!.name
                  : 'Seleccionar Categoría'),
              onChanged: (Category? newCategory) {
                setState(() {
                  selectedCategory = newCategory;
                });
              },
              items: [
                ...Provider.of<CategoriesProvider>(context)
                    .categories
                    .reversed
                    .map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddCategoryDialog(),
                    ).then((value) {
                      if (value != null && value is Category) {
                        setState(() {
                          selectedCategory = null;
                        });
                      }
                    });
                  },
                  child: Text('Agregar categoría'),
                ),
                SizedBox(width: 8), // Espacio entre el botón y el icono
                IconButton(
                  icon:
                      Icon(Icons.info, color: Color.fromARGB(255, 6, 206, 178)),
                  onPressed: () {
                    // Mostrar un mensaje cuando se hace clic en el icono de información
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Información',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        content: Text(
                            'Si la categoría que buscas no existe, puedes agregarla desde Botón Agregar categoría.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Elegir una prioridad'),
            SizedBox(height: 8),
            ToggleButtons(
              isSelected: [
                taskPriority == 'Baja',
                taskPriority == 'Media',
                taskPriority == 'Alta'
              ],
              onPressed: (int index) {
                setState(() {
                  switch (index) {
                    case 0:
                      taskPriority = 'Baja';
                      break;
                    case 1:
                      taskPriority = 'Media';
                      break;
                    case 2:
                      taskPriority = 'Alta';
                      break;
                  }
                });
              },
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'Baja',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'Media',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'Alta',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
              color: Colors.grey[600],
              selectedColor: Colors.white,
              selectedBorderColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
              borderWidth: 2,
              fillColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16),
            Text('Cambiar Estado'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        taskStatus = 'Pendiente';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      decoration: BoxDecoration(
                        color: taskStatus == 'Pendiente'
                            ? Colors.blue.shade100
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: taskStatus == 'Pendiente'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<String>(
                            value: 'Pendiente',
                            groupValue: taskStatus,
                            onChanged: (String? value) {
                              setState(() {
                                taskStatus = value ?? '';
                              });
                            },
                          ),
                          Text(
                            'Pendiente',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: taskStatus == 'Pendiente'
                                  ? Colors.blue
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        taskStatus = 'Completado';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      decoration: BoxDecoration(
                        color: taskStatus == 'Completado'
                            ? Colors.green.shade100
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: taskStatus == 'Completado'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<String>(
                            value: 'Completado',
                            groupValue: taskStatus,
                            onChanged: (String? value) {
                              setState(() {
                                taskStatus = value ?? '';
                              });
                            },
                          ),
                          Text(
                            'Completado',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: taskStatus == 'Completado'
                                  ? Colors.green
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Seleccionar fecha y hora limite'),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectDate,
                    child: Text(
                        'Fecha: ${DateFormat.yMd().format(_selectedDate)}'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectTime,
                    child:
                        Text('Hora: ${DateFormat.Hm().format(_selectedDate)}'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (taskTitle.isNotEmpty &&
                    taskDescription.isNotEmpty &&
                    selectedCategory != null) {
                  final categoryId = selectedCategory!.id;
                  if (categoryId != null) {
                    Provider.of<TasksProvider>(context, listen: false)
                        .updateTask(
                      Task(
                        id: widget.task.id,
                        title: taskTitle,
                        description: taskDescription,
                        categoryId: selectedCategory!.id!,
                        date: _selectedDate,
                        priority: taskPriority,
                        status: taskStatus,
                      ),
                    );
                    Navigator.of(context).pop();
                    _unfocusSearchField();
                  }
                }
              },
              child: Text(
                'Guardar cambios',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

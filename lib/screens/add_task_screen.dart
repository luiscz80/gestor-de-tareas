import 'package:tareas/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../models/categories.dart';
import '../models/task.dart';
import '../providers/tasks_provider.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priorityController = TextEditingController();
  Category? selectedCategory;
  DateTime _selectedDate = DateTime.now();

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

  void _addTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final priority = _priorityController.text.trim();
    final status = "Pendiente";

    if (description.isEmpty ||
        title.isEmpty ||
        description.isEmpty ||
        priority.isEmpty ||
        status.isEmpty ||
        selectedCategory == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Campos vacíos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: Text('Por favor, complete todos los campos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    final newTask = Task(
      id: null,
      title: title,
      categoryId: selectedCategory!.id!,
      description: description,
      date: _selectedDate,
      priority: priority,
      status: status,
    );

    Provider.of<TasksProvider>(context, listen: false).addTask(newTask);
    Navigator.pop(context);
    _unfocusSearchField();
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoriesProvider>(context);

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
                    'Registrar tarea',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Text('Título de tarea'),
              TextField(
                controller: _titleController,
                decoration:
                    InputDecoration(labelText: 'Ingrese el título de la tarea'),
              ),
              SizedBox(height: 16),
              Text('Descripción de tarea'),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    labelText: 'Ingrese la descripción de la tarea'),
              ),
              SizedBox(height: 16),
              Text('Elegir categoría'),
              DropdownButton<Category>(
                hint: Text(selectedCategory != null
                    ? selectedCategory!.name
                    : 'Seleccionar Categoría'),
                value: selectedCategory,
                onChanged: (Category? newCategory) {
                  setState(() {
                    selectedCategory = newCategory;
                  });
                },
                items: categoryViewModel.categories.reversed
                    .map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
              ),
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
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.info,
                        color: Color.fromARGB(255, 6, 206, 178)),
                    onPressed: () {
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
                  _priorityController.text == 'Baja',
                  _priorityController.text == 'Media',
                  _priorityController.text == 'Alta'
                ],
                onPressed: (int index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        _priorityController.text = 'Baja';
                        break;
                      case 1:
                        _priorityController.text = 'Media';
                        break;
                      case 2:
                        _priorityController.text = 'Alta';
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'Media',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'Alta',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
              Text('Seleccionar fecha y hora limite'),
              GestureDetector(
                onTap: () async {
                  await _selectDate();
                  await _selectTime();
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text(
                      DateFormat('dd/MM/yyyy - HH:mm').format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addTask,
                child: Text(
                  'Registrar tarea',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCategoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoriesProvider>(context);
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _categoryNameController =
        TextEditingController();

    return AlertDialog(
      title: Text('Agregar Categoría',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _categoryNameController,
          decoration: InputDecoration(
            hintText: 'Nombre de la categoría',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El nombre es requerido';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCategory = Category(
                name: _categoryNameController.text,
              );
              categoryViewModel.addCategory(newCategory);
              Navigator.of(context).pop();
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}

import 'package:tareas/models/categories.dart';
import 'package:tareas/providers/auth_provider.dart';
import 'package:tareas/providers/categories_provider.dart';

import 'package:tareas/screens/modify_pin_screen.dart';
import 'package:tareas/screens/profile_screen.dart';
import 'package:tareas/screens/welcome_screen.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:tareas/providers/users_provider.dart';
import 'package:tareas/providers/tasks_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _exportAllTasksToCSV(BuildContext context) async {
    final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
    final tasks = tasksProvider.tasks;
    final categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    List<List<dynamic>> rows = [
      [
        "Titulo tarea",
        "Descripcion",
        "Categoria",
        "Prioridad",
        "Estado",
        "Fecha"
      ]
    ];

    for (var task in tasks) {
      List<dynamic> row = [];
      row.add(task.title);
      row.add(task.description);

      String categoryName = categoryProvider.categories
          .firstWhere((cat) => cat.id == task.categoryId,
              orElse: () => Category(name: 'Categoría no encontrada'))
          .name;
      row.add(categoryName);
      row.add(task.priority);
      row.add(task.status);

      String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(task.date);
      row.add(formattedDate);

      rows.add(row);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final downloadsDirectory = await getExternalStorageDirectory();

    if (downloadsDirectory == null) {
      showCustomSnackBar(context, 'Error al obtener el directorio.');
      return;
    }

    List<FileSystemEntity> files =
        Directory(downloadsDirectory.path).listSync();
    int maxIndex = 0;
    for (var file in files) {
      if (file is File && file.path.contains('tareas')) {
        String fileName = file.path.split('/').last;
        String fileNumberString =
            fileName.substring(6, fileName.indexOf('.csv'));
        int fileNumber = int.tryParse(fileNumberString) ?? 0;
        if (fileNumber > maxIndex) {
          maxIndex = fileNumber;
        }
      }
    }

    final file = File('${downloadsDirectory.path}/tareas${maxIndex + 1}.csv');
    await file.writeAsString(csvData, encoding: utf8);

    showCustomSnackBar(
        context, 'Las Tareas han sido exportados a: ${file.path}.');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Archivo CSV",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Text("El archivo CSV se ha guardado en ${file.path}"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
            TextButton(
              onPressed: () {
                OpenFile.open(file.path);
              },
              child: Text('Abrir CSV'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: userProvider.users.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuario',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Color.fromARGB(255, 6, 206, 178),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProvider.users.first.name.length > 20
                                ? userProvider.users.first.name
                                        .substring(0, 20) +
                                    "..."
                                : userProvider.users.first.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            userProvider.users.first.cedula.toString(),
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Opciones',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person,
                          color: Theme.of(context).primaryColor),
                      title: Text(
                        'Actualizar datos',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder: (_, __, ___) => ProfileScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.lock,
                          color: Color.fromARGB(255, 248, 172, 84)),
                      title: Text(
                        'Modificar pin de seguridad',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder: (_, __, ___) => ModifyPinScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.fingerprint, color: Colors.blue),
                      title: Text(
                        'Usar el sensor de huella',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Switch(
                        value: Provider.of<AuthProvider>(context)
                            .useBiometricsTask,
                        onChanged: (bool value) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .setUseBiometrics(value);
                          if (value) {
                            showCustomSnackBar(context,
                                'Se activó el uso del sensor de huella.');
                          } else {
                            showCustomSnackBar(context,
                                'Se desactivó el uso del sensor de huella.');
                          }
                        },
                        activeColor: Colors.white60,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.download, color: Colors.green),
                      title: Text(
                        'Exportar Tareas a CSV',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        final categoryProvider =
                            Provider.of<CategoriesProvider>(context,
                                listen: false);

                        print(categoryProvider.categories.first.name);

                        _exportAllTasksToCSV(context);
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text('Cerrar sesión',
                          style: TextStyle(color: Colors.red, fontSize: 14)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Cerrar Sesión",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor)),
                              content: Text(
                                "¿Está seguro de que desea cerrar sesión? Sus datos se **borrarán** y deberá ingresar nuevamente.",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cerrar el diálogo
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    userProvider
                                        .logoutUser(); // Elimina los datos de la BD
                                    Navigator.of(context)
                                        .pop(); // Cerrar el diálogo
                                    showCustomSnackBar(context,
                                        'La sesión se cerró con éxito, vuelva a Ingresar sus datos.');
                                    Navigator.of(context).pushReplacement(
                                      // Redirecciona a WelcomeScreen
                                      MaterialPageRoute(
                                        builder: (context) => WelcomeScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Cerrar Sesión',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Versión',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.info,
                          color: Theme.of(context).primaryColor),
                      title: Text(
                        'Gestor de Tareas 1.0.0',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

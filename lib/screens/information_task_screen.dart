import 'package:tareas/models/categories.dart';
import 'package:tareas/models/task.dart';
import 'package:tareas/providers/categories_provider.dart';
import 'package:tareas/screens/DueTasksScreen.dart';
import 'package:tareas/screens/about_us_screen.dart';
import 'package:tareas/screens/pending_task_screen.dart';
import 'package:tareas/screens/documentation_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tareas/screens/category_list_screen.dart';

import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/users_provider.dart';

class InformationTaskScreen extends StatefulWidget {
  const InformationTaskScreen({super.key});

  @override
  _InformationTaskScreenState createState() => _InformationTaskScreenState();
}

class _InformationTaskScreenState extends State<InformationTaskScreen> {
  int _currentPage = 0;
  bool _isLoading = true;
  bool showUserData = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
    showUserData = false;
  }

  void _getUserData() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.fetchUserData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Cargando datos...',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor)),
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(12.0),
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Consumer<UsersProvider>(
                              builder: (context, usersProvider, child) {
                                final user = usersProvider.users.first;
                                return Column(
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            child: Icon(
                                              Icons.person,
                                              size: 25,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showUserData = !showUserData;
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Hola, ${user.name.length > 20 ? user.name.substring(0, 20) + "..." : user.name}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (showUserData)
                                            Column(
                                              children: [
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.credit_card,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '${user.cedula}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 1),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.phone,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '${user.phoneNumber}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                  255, 61, 59, 65),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.person_rounded,
                                              color: Color.fromARGB(
                                                  255, 6, 206, 178),
                                            ),
                                            label: Text(
                                              'Guía de usuario',
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 600),
                                                  pageBuilder: (_, __, ___) =>
                                                      DocumentationScreen(),
                                                  transitionsBuilder: (_,
                                                      animation, __, child) {
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
                                        ),
                                        SizedBox(width: 14),
                                        Flexible(
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                  255, 61, 59, 65),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.phone_android_outlined,
                                              color: Color.fromARGB(
                                                  255, 6, 206, 178),
                                            ),
                                            label: Text(
                                              'Acerca de app',
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 600),
                                                  pageBuilder: (_, __, ___) =>
                                                      AboutUsScreen(),
                                                  transitionsBuilder: (_,
                                                      animation, __, child) {
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
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 2),
                    _actionButtons(context),
                  ],
                )),
              ],
            ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton('Tareas Pendientes', Icons.check_circle,
                  const Color.fromARGB(255, 31, 97, 151), context),
              _buildActionButton('Tareas Vencidas', Icons.warning,
                  const Color.fromARGB(255, 209, 66, 56), context),
              _buildActionButton('Mis Categorías', Icons.folder,
                  const Color.fromARGB(255, 62, 155, 65), context),
            ],
          ),
          SizedBox(height: 16),
          _carouselContent(context),
          _buildTransactionList(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, Color color, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            switch (title) {
              case 'Tareas Pendientes':
                _navigateWithTransition(context, PendingTasksScreen());
                break;
              case 'Tareas Vencidas':
                _navigateWithTransition(context, DueTasksScreen());
                break;
              case 'Mis Categorías':
                _navigateWithTransition(context, CategoryScreen());
                break;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: color.withOpacity(0.6), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: color),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateWithTransition(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  Widget _carouselContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 10.0, 0.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 255, 252),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 60,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                    items: [
                      _buildCarouselItem('assets/slider/task.png',
                          '¡Gestiona tus tareas de manera fácil y eficiente con nuestra interfaz intuitiva!'),
                      _buildCarouselItem('assets/slider/categories.png',
                          '¡Organiza tus tareas por categorías para un control más efectivo y estructurado!'),
                      _buildCarouselItem('assets/slider/productivity.png',
                          '¡Visualiza tu progreso y productividad con gráficos que muestran tus tareas completadas y pendientes!'),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Color.fromARGB(255, 6, 206, 178)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String icon, String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 40,
            height: 40,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3.0, 0.0, 10.0, 5.0),
      child: Row(
        children: [
          Expanded(
            child: Consumer<TasksProvider>(
              builder: (context, taskViewModel, child) {
                if (taskViewModel.tasks.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Tareas recientes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Aún no hay registro de tareas',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Tareas recientes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 0),
                      ...List.generate(
                        taskViewModel.tasks.length,
                        (index) {
                          final int reversedIndex =
                              taskViewModel.tasks.length - 1 - index;
                          final Task task = taskViewModel.tasks[reversedIndex];

                          return _buildTransactionItem(
                            Text(
                              task.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            '${task.description}',
                            Provider.of<CategoriesProvider>(context,
                                    listen: false)
                                .categories
                                .firstWhere(
                                  (category) => category.id == task.categoryId,
                                  orElse: () =>
                                      Category(id: -1, name: 'No definida'),
                                )
                                .name
                                .toUpperCase(),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      Widget title, String description, String category) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.assignment_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: title,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    '$description',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 6, 206, 178),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    maxChildSize: 0.4,
                    minChildSize: 0.1,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Detalles de la Tarea',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 206, 178),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    'Tarea: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: title,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Descripción: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      description,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Categoría: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
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
              );
            },
            label: const Text(
              'Ver',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

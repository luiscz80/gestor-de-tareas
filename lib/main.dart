import 'package:permission_handler/permission_handler.dart';
import 'package:tareas/providers/categories_provider.dart';
import 'package:tareas/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/tasks_provider.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'utils/database_helper.dart';
import 'utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    initializeDateFormatting('es');
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestor de tareas',
        theme: ThemeData(
          primaryColor: Color(0xFF2E3A59),
          fontFamily: 'MontserratAlternates',
        ),
        home: FutureBuilder<bool>(
          future: _checkStoredUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              bool userExists = snapshot.data ?? false;
              return userExists ? LoginScreen() : WelcomeScreen();
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/welcome': (context) => WelcomeScreen(),
        },
      ),
    );
  }

  Future<bool> _checkStoredUserData() async {
    final dbHelper = DatabaseHelper.instance;
    final userData = await dbHelper.getUserData();
    return userData != null && userData['code'] != null;
  }
}

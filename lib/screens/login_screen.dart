import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tareas/models/users.dart';
import 'package:provider/provider.dart';
import 'package:tareas/providers/auth_provider.dart';
import 'package:tareas/providers/users_provider.dart';
import 'package:tareas/screens/home_screen.dart';
import 'package:tareas/screens/remember_pin_screen.dart';
import 'package:tareas/widgets/snackbar_message.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  late List<TextEditingController> _controllers;
  final LocalAuthentication localAuth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _formattedName = '';

  @override
  void initState() {
    super.initState();
    _getNameUser();
    Provider.of<AuthProvider>(context, listen: false).loadPreference();
    _controllers = List.generate(4, (index) => TextEditingController());

    _checkBiometricsAndAuthenticate();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _getNameUser() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.fetchUserData();
    List<User> users = usersProvider.users;
    if (users.isNotEmpty) {
      String nameUser = users.first.name;
      if (nameUser.length >= 4) {
        setState(() {
          _formattedName = '${nameUser.trim().split(' ').first}';
        });
      }
    }
  }

  void _handleInputChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index + 1 < 4) {
        FocusScope.of(context).nextFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    } else {
      if (index - 1 >= 0) {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 6, 206, 178), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.black87, fontSize: 14),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _authenticate(
      bool useBiometricsTask, BuildContext context) async {
    setState(() {
      _isAuthenticated = true;
    });

    bool isAuthenticated = false;

    String pin = _controllers.map((e) => e.text).join();
    if (pin.length == 4) {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      await usersProvider.fetchUserData();

      final storedPin = usersProvider.users.isNotEmpty
          ? usersProvider.users.first.code
          : null;

      if (storedPin != null && pin == storedPin) {
        isAuthenticated = true;
      } else {
        showCustomSnackBar(context, 'El PIN de acceso es incorrecto.');
        setState(() {
          for (var controller in _controllers) {
            controller.clear();
          }
        });
      }
    } else {
      showCustomSnackBar(context, 'Por favor, ingresa tu PIN de 4 dígitos.');
    }

    if (isAuthenticated) {
      _navigateToHomeScreenWithAnimation();
    } else {
      if (useBiometricsTask && !isAuthenticated) {
        try {
          isAuthenticated = await localAuth.authenticate(
            localizedReason: 'Escanea tu huella dactilar para desbloquear',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ),
          );
        } catch (e) {
          showCustomSnackBar(context, 'Error de autenticación biométrica.');
        }
      }

      if (isAuthenticated) {
        _navigateToHomeScreenWithAnimation();
      } else {
        setState(() {
          _isAuthenticated = false;
        });
      }
    }
  }

  Future<void> _checkBiometricsAndAuthenticate() async {
    bool useBiometricsTask =
        Provider.of<AuthProvider>(context, listen: false).useBiometricsTask;

    if (useBiometricsTask) {
      try {
        bool isAuthenticated = await localAuth.authenticate(
          localizedReason: 'Escanea tu huella dactilar para desbloquear',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (isAuthenticated) {
          _navigateToHomeScreenWithAnimation();
        } else {
          showCustomSnackBar(
              context, 'El usuario canceló la operación de huella dactilar.');
        }
      } on PlatformException catch (e) {
        if (e.code == 'NotAvailable') {
          showCustomSnackBar(context,
              'La autenticación biométrica no está disponible en este dispositivo.');
        } else if (e.code == 'NotEnrolled') {
          showCustomSnackBar(context,
              'No hay huellas dactilares registradas en este dispositivo.');
        } else {
          showCustomSnackBar(context, 'Error de autenticación biométrica.');
        }
      }
    }
  }

  void _navigateToHomeScreenWithAnimation() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool useBiometricsTask =
        Provider.of<AuthProvider>(context).useBiometricsTask;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () {
                      _showAppInfoBottomSheet(context);
                    },
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                'assets/lock.png',
                height: 116,
              ),
              SizedBox(height: 16),
              Text(
                _formattedName.isEmpty
                    ? '...'
                    : '¡Bienvenid@ ${_formattedName}!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Usa tu pin de seguridad',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: TextFormField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            obscureText: _obscureText,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 6, 206, 178),
                              fontSize: 24,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: '•',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            onChanged: (value) =>
                                _handleInputChange(value, index),
                            textInputAction: index < 3
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onEditingComplete: () {
                              if (index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                  IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isAuthenticated
                    ? null
                    : () => _authenticate(useBiometricsTask, context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  textStyle: TextStyle(fontSize: 20),
                  backgroundColor: Color.fromARGB(255, 6, 206, 178),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: _isAuthenticated
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Desbloquear',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'MontserratAlternates'),
                          ),
                        ],
                      ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder: (_, __, ___) => RememberPinScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                        begin: Offset(0, 1), end: Offset.zero)
                                    .animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        '¿No recuerdas tu pin?',
                        style: TextStyle(fontSize: 15, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.info,
                        color: Color.fromARGB(255, 6, 206, 178), size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Información de la Aplicación',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Gestor de Tareas es una aplicación diseñada para ayudarte a organizar tus tareas de manera eficiente y productiva.',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Características clave:',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildFeatureRow(
                  Icons.check,
                  'Agendamiento de tareas con fechas límite personalizadas.',
                ),
                _buildFeatureRow(
                  Icons.check,
                  'Clasificación de tareas mediante categorías para mejor organización.',
                ),
                _buildFeatureRow(
                  Icons.check,
                  'Notificaciones automáticas para tareas pendientes y vencidas, asegurando que no se olviden.',
                ),
                _buildFeatureRow(
                  Icons.check,
                  'Visualización detallada de tareas mediante gráficos de rendimiento.',
                ),
                _buildFeatureRow(
                  Icons.check,
                  'Capacidad de exportar tus tareas a formato CSV para un fácil análisis y almacenamiento.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

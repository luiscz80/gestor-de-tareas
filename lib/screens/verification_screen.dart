import 'dart:async';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:tareas/models/users.dart';
import 'package:tareas/providers/users_provider.dart';
import 'package:tareas/widgets/help_contact.dart';
import 'package:tareas/screens/unlock_screen.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinDeSeguridadScreen extends StatefulWidget {
  final String phoneNumber;

  PinDeSeguridadScreen({required this.phoneNumber});

  @override
  _PinDeSeguridadScreenState createState() => _PinDeSeguridadScreenState();
}

class _PinDeSeguridadScreenState extends State<PinDeSeguridadScreen> {
  Future<void> _generateVerificationCodeAndSendMessage(
      String phoneNumber, String nameUser, String cedula) async {
    try {
      // Generar código de verificación de 4 dígitos
      String verificationCode = _generateVerificationCode();

      // Actualizar el código de verificación en la base de datos
      UsersProvider usersProvider =
          Provider.of<UsersProvider>(context, listen: false);
      await usersProvider.updateVerificationCode(phoneNumber, verificationCode);

      // Mostrar diálogo de confirmación
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pin de seguridad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: RichText(
              text: TextSpan(
                text: 'Su pin de seguridad es: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: '$verificationCode',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  FlutterClipboard.copy(verificationCode).then((value) {
                    Navigator.of(context).pop();
                    showCustomSnackBar(context, 'Pin copiado al portapapeles.');
                  });
                },
                child: Text(
                  'Copiar PIN',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Mostrar diálogo de error si falla el envío del mensaje SMS
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'No se pudo generar el PIN de seguridad, inténtelo de nuevo.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  String _generateVerificationCode() {
    // Generar un pin de seguridad aleatorio de 4 dígitos
    return '${1000 + Random().nextInt(9000)}';
  }

  TextEditingController _pinController = TextEditingController();
  int _counter = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _counter = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin(String pin) async {
    bool isValidPin = await _checkPinFromDatabase(pin);
    if (isValidPin) {
      showCustomSnackBar(
          context, 'El PIN de seguridad ha sido verificado con éxito.');

      // Cerrar el mensaje después de 2 segundo y luego navegar con animación
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) =>
              DesbloqueoScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      showCustomSnackBar(context, 'El PIN de seguridad debe ser la correcta.');
    }
  }

  Future<bool> _checkPinFromDatabase(String pin) async {
    final usersProvider = UsersProvider();
    User? user = await usersProvider.getUserByPin(pin);

    // Verificar si se obtuvo un usuario y si el código coincide
    if (user != null && user.code == pin) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Text(
                    'Pin de seguridad',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Icon(Icons.sms, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'MontserratAlternates'),
                            children: [
                              TextSpan(
                                text:
                                    'Genere un pin de seguridad de 4 dígitos, esto es para validar su registro.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Icon(Icons.security, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'El pin de seguridad será el código de confirmación y servirá para desbloquear la aplicación, podrás cambiarlo en cualquier momento.',
                          style: TextStyle(
                              fontSize: 15, fontFamily: 'MontserratAlternates'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'Pin de seguridad',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_counter > 0)
                    GestureDetector(
                      onTap: () {
                        String nameUser = '';
                        String cedula = '';
                        _generateVerificationCodeAndSendMessage(
                            widget.phoneNumber, nameUser, cedula);

                        startTimer();
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Generar PIN de seguridad en ',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'MontserratAlternates'),
                            ),
                            TextSpan(
                              text: '$_counter seg.',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MontserratAlternates'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: 0.66,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 6, 206, 178),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('2 de 3 pasos'),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      String pin = _pinController.text;
                      _verifyPin(pin);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      textStyle: TextStyle(fontSize: 20),
                      backgroundColor: Color.fromARGB(255, 57, 52, 66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Color.fromARGB(255, 6, 206, 178),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Verificar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'MontserratAlternates'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  HelpContactWidget(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

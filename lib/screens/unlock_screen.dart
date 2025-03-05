import 'package:tareas/providers/auth_provider.dart';
import 'package:tareas/widgets/help_contact.dart';
import 'package:tareas/screens/home_screen.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesbloqueoScreen extends StatefulWidget {
  @override
  _DesbloqueoScreenState createState() => _DesbloqueoScreenState();
}

class _DesbloqueoScreenState extends State<DesbloqueoScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloquear retroceso
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Desbloqueo de la aplicación',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.lightbulb_outline,
                            color: Colors.yellow, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Utiliza el sensor de huella para desbloquear la aplicación en lugar de ingresar el pin de seguridad.',
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Icon(Icons.fingerprint, size: 100, color: Colors.blue),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Usar el sensor de huella',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(width: 10),
                        Switch(
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
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.security, color: Colors.grey, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'La seguridad biométrica es gestionada por tu dispositivo. Si presenta algún problema, se solicitará el pin de seguridad.',
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: 1.0,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 6, 206, 178),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('3 de 3 pasos'),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomeScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(-1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                        showCustomSnackBar(context,
                            'Bienvenido a la Aplicación de Gestor de Tareas.');
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
                            Icons.home,
                            color: Color.fromARGB(255, 6, 206, 178),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Empezar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'MontserratAlternates'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    HelpContactWidget(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

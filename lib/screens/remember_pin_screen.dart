import 'package:tareas/models/users.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:tareas/providers/users_provider.dart';
import 'package:provider/provider.dart';

class RememberPinScreen extends StatefulWidget {
  @override
  _RememberPinScreenState createState() => _RememberPinScreenState();
}

class _RememberPinScreenState extends State<RememberPinScreen> {
  String _formattedPhoneNumber = '******';

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
  }

  void _getPhoneNumber() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.fetchUserData();
    List<User> users = usersProvider.users;
    if (users.isNotEmpty) {
      String phoneNumber = users.first.phoneNumber;
      if (phoneNumber.length >= 2) {
        setState(() {
          _formattedPhoneNumber =
              '******${phoneNumber.substring(phoneNumber.length - 2)}';
        });
      }
    }
  }

  void _logout(BuildContext context) async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.logoutUser();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome',
      (route) => false,
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text('¿Está seguro de que desea cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Continuar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
                showCustomSnackBar(context,
                    'La sesión se cerró con éxito, vuelva a Ingresar sus datos.');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            iconSize: 34,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        elevation: 0,
      ),
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
                  '¿No recuerdas tu pin?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.sms,
                      color: Color.fromARGB(255, 6, 206, 178),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'MontserratAlternates'),
                          children: [
                            TextSpan(
                              text:
                                  'Al ingresar por primera vez, enviamos el pin de seguridad al número $_formattedPhoneNumber, revisa tus ',
                            ),
                            TextSpan(
                              text: 'mensajes de texto',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                    Icon(Icons.warning,
                        color: Color.fromARGB(255, 233, 162, 29)),
                    SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'MontserratAlternates'),
                          children: [
                            TextSpan(
                              text:
                                  'Si cambiaste el pin de seguridad y no lo recuerdas, tendrás que ',
                            ),
                            TextSpan(
                              text: 'cerrar sesión',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' y volver a ingresar',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: TextStyle(fontSize: 20),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'MontserratAlternates'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

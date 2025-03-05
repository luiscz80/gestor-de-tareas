import 'package:tareas/models/users.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users_provider.dart';

class ModifyPinScreen extends StatefulWidget {
  @override
  _ModifyPinScreenState createState() => _ModifyPinScreenState();
}

class _ModifyPinScreenState extends State<ModifyPinScreen> {
  late UsersProvider _usersProvider;
  User? _user;
  final TextEditingController _currentPin = TextEditingController();
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usersProvider = Provider.of<UsersProvider>(context, listen: false);
    _loadUserData();
  }

  void _loadUserData() {
    _user = _usersProvider.users.isNotEmpty ? _usersProvider.users.first : null;
    if (_user != null) {
      _currentPin.text = _user!.code;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'Modificar pin',
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recuerda que si cambias tu PIN de seguridad, deberás recordarlo para poder ingresar a la aplicación.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'Tu pin actual es: ${_currentPin.text}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _currentPinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Ingrese su PIN actual',
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF757575),
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El PIN actual es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _newPinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Ingrese el Nuevo PIN',
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF757575),
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nuevo PIN es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar nuevo PIN',
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF757575),
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La confirmación del nuevo PIN es requerida';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updatePin(context);
                    }
                  },
                  child: Text(
                    'Modificar PIN',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updatePin(BuildContext context) async {
    final String currentPin = _currentPinController.text.trim();
    final String newPin = _newPinController.text.trim();
    final String confirmPin = _confirmPinController.text.trim();

    // Verificar si el nuevo PIN coincide con la confirmación
    if (newPin != confirmPin) {
      showCustomSnackBar(
          context, 'El nuevo PIN y la confirmación no coinciden.');
      return;
    }

    // Verificar si el PIN actual existe en la base de datos
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final currentPinExists = await usersProvider.getUserByPin(currentPin);
    print(currentPinExists);

    if (currentPinExists == null) {
      showCustomSnackBar(context,
          'El PIN actual no existe en la base de datos, Inténtelo de nuevo.');
      return;
    }

    try {
      await usersProvider.updatePin(currentPin, newPin);
      showCustomSnackBar(context, 'El PIN ha sido modificado con éxito.');

      // Actualizar el pin actual en la UI
      setState(() {
        _currentPin.text = newPin;
        _currentPinController.clear();
        _newPinController.clear();
        _confirmPinController.clear();
      });
    } catch (e) {
      showCustomSnackBar(
          context, 'Error al modificar el PIN, Inténtelo de nuevo.');
    }
  }
}

import 'package:tareas/models/users.dart';
import 'package:tareas/providers/users_provider.dart';
import 'package:tareas/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UsersProvider _usersProvider;
  User? _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _nameError = false;
  bool _phoneError = false;
  bool _cedulaError = false;

  @override
  void initState() {
    super.initState();
    _usersProvider = Provider.of<UsersProvider>(context, listen: false);
    _loadUserData();
  }

  void _loadUserData() {
    _user = _usersProvider.users.isNotEmpty ? _usersProvider.users.first : null;
    if (_user != null) {
      _nameController.text = _user!.name;
      _cedulaController.text = _user!.cedula;
      _phoneController.text = _user!.phoneNumber;
      _addressController.text = _user!.address;
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
                    'Actualizar datos',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Consumer<UsersProvider>(
        builder: (context, usersProvider, child) {
          _user =
              usersProvider.users.isNotEmpty ? usersProvider.users.first : null;
          if (_user == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                SizedBox(height: 20.0),
                _buildTextField(
                    Icons.person, 'Nombre de usuario', _nameController,
                    errorText: _nameError
                        ? 'El nombre de usuario es requerido'
                        : null),
                SizedBox(height: 20.0),
                _buildTextField(
                    Icons.credit_card, 'Cédula de identidad', _cedulaController,
                    keyboardType: TextInputType.number,
                    errorText: _cedulaError
                        ? 'La cédula de identidad es requerida'
                        : null),
                SizedBox(height: 20.0),
                _buildTextField(
                    Icons.numbers, 'Número de celular', _phoneController,
                    keyboardType: TextInputType.number,
                    errorText: _phoneError
                        ? 'el número de celular es requerida'
                        : null),
                SizedBox(height: 20.0),
                _buildTextField(
                    Icons.location_city, 'Dirección', _addressController),
                SizedBox(height: 20.0),
                _buildSaveButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          child: Icon(
            Icons.person,
            size: 50,
            color: Color.fromARGB(255, 6, 206, 178),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Mi Perfil',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        Text(
          _user != null ? _user!.name : '',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 5.0),
      ],
    );
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, String? errorText}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor),
        child: Text('Actualizar datos'),
      ),
    );
  }

  void _saveChanges() {
    setState(() {
      _nameError = _nameController.text.isEmpty;
      _cedulaError = _cedulaController.text.isEmpty;
      _phoneError = _phoneController.text.isEmpty;
    });

    if (_nameError || _cedulaError || _phoneError) {
      return;
    }

    String newName = _nameController.text;
    String newCedula = _cedulaController.text;
    String newPhone = _phoneController.text;
    String newAddress = _addressController.text;

    // Actualizar los datos del usuario en el provider
    if (_user != null) {
      _user!.name = newName;
      _user!.cedula = newCedula;
      _user!.phoneNumber = newPhone;
      _user!.address = newAddress;
      _usersProvider.updateUser(_user!).then((_) {
        setState(() {
          _user = _usersProvider.users.first;
        });
        _showUpdateProfileDialog();
      });
    }
  }

  void _showUpdateProfileDialog() {
    showCustomSnackBar(context, 'Los datos se actualizarón con éxito.');
  }
}

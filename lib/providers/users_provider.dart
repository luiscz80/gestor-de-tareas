import 'package:flutter/material.dart';
import '../models/users.dart';
import '../utils/database_helper.dart';

class UsersProvider extends ChangeNotifier {
  List<User> _user = [];
  bool _isAuthenticated = false;

  List<User> get users => _user;
  bool get isAuthenticated => _isAuthenticated;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  UsersProvider() {
    _fetchUser();
    _loadData();
  }

  Future<void> _fetchUser() async {
    _user = await _dbHelper.getUser();
    _isAuthenticated = _user.isNotEmpty;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    _user = await _dbHelper.getUser();
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await _dbHelper.insertUser(user);
    _fetchUser();
  }

  Future<void> updateUser(User user) async {
    await _dbHelper.updateUser(user);
    _fetchUser();
  }

  Future<void> deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _fetchUser();
  }

  Future<void> _loadData() async {
    _user = await _dbHelper.getUser();
    _isAuthenticated = _user.isNotEmpty;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await _deleteUserFromDatabase();
    _user.clear();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> _deleteUserFromDatabase() async {
    List<User> users = await _dbHelper.getUser();
    if (users.isNotEmpty) {
      User user = users.first;
      await _dbHelper.deleteUser(user.id!);
    }
  }

  // Función para actualizar el PIN de seguridad
  Future<void> updatePin(String currentPin, String newPin) async {
    try {
      List<User> users = _user;

      if (users.isNotEmpty) {
        User user = users.first;

        if (user.code == currentPin) {
          await _dbHelper.updatePin(user.id!, newPin);
          user.code = newPin;

          notifyListeners();
        } else {
          throw Exception('El PIN actual no es correcto');
        }
      } else {
        throw Exception('No se encontró información del usuario');
      }
    } catch (e) {
      throw Exception('Error al actualizar el PIN: $e');
    }
  }

  Future<void> updateVerificationCode(String phoneNumber, String code) async {
    try {
      List<User> users = _user;

      // Verificar si hay al menos un usuario en la lista
      if (users.isNotEmpty) {
        User user = users.first;

        DatabaseHelper dbHelper = DatabaseHelper.instance;

        await dbHelper.updateVerificationCode(
            phoneNumber: phoneNumber, code: code);

        user.phoneNumber = phoneNumber;
        user.code = code;

        notifyListeners();
      } else {
        throw Exception('No se encontró información del usuario');
      }
    } catch (e) {
      throw Exception('Error al actualizar el código de verificación: $e');
    }
  }

  Future<User?> getUserByPin(String pin) async {
    String? code = await _dbHelper.queryPin(pin);
    if (code != null) {
      await _fetchUser();
      return _user.isNotEmpty ? _user.first : null;
    } else {
      return null;
    }
  }
}

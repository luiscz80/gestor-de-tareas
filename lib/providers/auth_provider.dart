import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _useBiometrics = false;

  bool get useBiometricsTask => _useBiometrics;

  AuthProvider() {
    loadPreference();
  }

  Future<void> loadPreference() async {
    String? value = await _secureStorage.read(key: 'useBiometricsTask');
    _useBiometrics = value == 'true';
    notifyListeners();
  }

  Future<void> setUseBiometrics(bool value) async {
    _useBiometrics = value;
    await _secureStorage.write(
        key: 'useBiometricsTask', value: value.toString());
    notifyListeners();
  }
}

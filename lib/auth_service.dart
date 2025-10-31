// lib/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  // Registrar nuevo usuario
  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Verificar si ya existe un usuario con ese nombre
    if (prefs.containsKey(_usernameKey)) {
      return false; // Ya existe
    }
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
    return true;
  }

  // Iniciar sesión
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString(_usernameKey);
    final savedPass = prefs.getString(_passwordKey);

    if (savedUser == username && savedPass == password) {
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }
    return false;
  }

  Future<void> clearRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(
      _isLoggedInKey,
    ); // también cerramos sesión si estaba activa
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Verificar si está logueado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Obtener nombre de usuario
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }
}

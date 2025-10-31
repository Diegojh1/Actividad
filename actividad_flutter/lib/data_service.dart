// lib/data_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  static const String _dataListKey = 'savedDataList';

  // Guardar un nuevo dato
  Future<void> saveData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = await getSavedData();

    // Evitar duplicados si lo deseas (opcional)
    if (!currentList.contains(data)) {
      currentList.add(data);
      await prefs.setString(_dataListKey, jsonEncode(currentList));
    }
  }

  // Obtener todos los datos guardados
  Future<List<String>> getSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_dataListKey);
    if (jsonString == null) return [];
    return List<String>.from(jsonDecode(jsonString));
  }

  // Actualizar un dato por índice
  Future<void> updateData(int index, String newValue) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getSavedData();
    if (index < 0 || index >= list.length) {
      return;
    }
    list[index] = newValue;
    await prefs.setString(_dataListKey, jsonEncode(list));
  }

  // Eliminar un dato por índice
  Future<void> removeAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getSavedData();
    if (index < 0 || index >= list.length) {
      return;
    }
    list.removeAt(index);
    await prefs.setString(_dataListKey, jsonEncode(list));
  }

  // Borrar todos los datos (opcional)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dataListKey);
  }
}

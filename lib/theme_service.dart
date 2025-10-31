import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeModeKey = 'themeMode';

  final ValueNotifier<ThemeMode> themeModeNotifier;

  ThemeService._(this.themeModeNotifier);

  static Future<ThemeService> create() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModeKey);
    final initialMode = _fromString(stored) ?? ThemeMode.system;
    return ThemeService._(ValueNotifier<ThemeMode>(initialMode));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _toString(mode));
  }

  Future<void> toggleDarkMode() async {
    final isDark = themeModeNotifier.value == ThemeMode.dark;
    await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  static ThemeMode? _fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
    }
    return null;
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

// Instancia global simple para acceso desde pantallas.
late ThemeService appThemeService;

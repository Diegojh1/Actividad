// lib/main.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'theme_service.dart';
import 'settings_screen.dart';
import 'saved_data_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = await ThemeService.create();
  appThemeService = themeService;
  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService.themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Gestión App',
          themeMode: mode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          routes: {
            '/login': (_) => LoginScreen(),
            '/home': (_) => HomeScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/saved': (_) => SavedDataScreen(),
          },
          home: FutureBuilder<bool>(
            future: AuthService().isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.data == true) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}

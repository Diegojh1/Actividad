import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: appThemeService.themeModeNotifier,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return SwitchListTile(
                title: const Text('Modo oscuro'),
                subtitle: const Text('Cambia entre claro y oscuro'),
                value: isDark,
                onChanged: (_) => appThemeService.toggleDarkMode(),
                secondary: const Icon(Icons.dark_mode),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión'),
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            onTap: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

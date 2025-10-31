// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'data_service.dart';
import 'saved_data_screen.dart'; // Nueva pantalla que crearemos
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController();
  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      await _dataService.saveData(_dataController.text.trim());
      _showSnackBar('Dato guardado correctamente');
      _dataController.clear();
    }
  }

  Future<void> _addDataViaDialog() async {
    final controller = TextEditingController();
    final value = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo dato'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Escribe algo',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (value != null && value.isNotEmpty) {
      await _dataService.saveData(value);
      if (!mounted) return;
      _showSnackBar('Dato guardado');
    }
  }

  void _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ajustes',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: FutureBuilder<String?>(
                future: _authService.getUsername(),
                builder: (context, snapshot) {
                  String user = snapshot.data ?? 'Usuario';
                  return Text(
                    'Bienvenido, $user! ',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  );
                },
              ),
              decoration: BoxDecoration(color: scheme.primary),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () async {
                String? user = await _authService.getUsername();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Usuario: $user')));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Datos ingresados'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                Navigator.pushNamed(context, '/saved');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Acerca de'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Acerca de'),
                    content: const Text('App de gestión de datos con Flutter.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Eliminar mi cuenta',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await _authService.clearRegistration();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingresa un dato para guardarlo:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Tu dato aquí',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa algún dato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveData,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Dato'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDataViaDialog,
        icon: const Icon(Icons.add),
        label: const Text('Añadir'),
      ),
    );
  }
}

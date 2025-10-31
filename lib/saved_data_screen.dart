// lib/saved_data_screen.dart
import 'package:flutter/material.dart';
import 'data_service.dart';

class SavedDataScreen extends StatefulWidget {
  @override
  State<SavedDataScreen> createState() => _SavedDataScreenState();
}

class _SavedDataScreenState extends State<SavedDataScreen> {
  final DataService _dataService = DataService();

  late Future<List<String>> _futureList;

  @override
  void initState() {
    super.initState();
    _futureList = _dataService.getSavedData();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureList = _dataService.getSavedData();
    });
  }

  Future<void> _editItem(int index, String current) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar dato'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nuevo valor',
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
    if (result != null && result.isNotEmpty) {
      await _dataService.updateData(index, result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dato actualizado')),
      );
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos Ingresados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              await _dataService.clearAllData();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todos los datos han sido eliminados')),
              );
              await _refresh();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final dataList = snapshot.data ?? [];

          if (dataList.isEmpty) {
            return const Center(
              child: Text(
                'No hay datos guardados aún.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final item = dataList[index];
                return Dismissible(
                  key: ValueKey('item_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await _dataService.removeAt(index);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dato eliminado')),
                    );
                    await _refresh();
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editItem(index, item),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

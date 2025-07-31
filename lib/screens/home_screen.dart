import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gatos_ingresos/providers/movimiento_provider.dart';
import '../models/movimiento.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movimientos = ref.watch(movimientosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Finanzas')),
      body: movimientos.isEmpty
          ? const Center(child: Text('No hay movimientos'))
          : ListView.builder(
              itemCount: movimientos.length,
              itemBuilder: (context, index) {
                final m = movimientos[index];
                return ListTile(
                  leading: Icon(
                    m.tipo == 'ingreso'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: m.tipo == 'ingreso' ? Colors.green : Colors.red,
                  ),
                  title: Text(m.descripcion),
                  subtitle: Text(m.fecha.toLocal().toString()),
                  trailing: Text(
                    '\$${m.cantidad.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: m.tipo == 'ingreso' ? Colors.green : Colors.red,
                    ),
                  ),
                  onLongPress: () {
                    ref
                        .read(movimientosProvider.notifier)
                        .eliminarMovimiento(m.id!);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoAgregar(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoAgregar(BuildContext context, WidgetRef ref) {
    final descController = TextEditingController();
    final cantidadController = TextEditingController();
    String tipo = 'gasto';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo Movimiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            DropdownButton<String>(
              value: tipo,
              items: const [
                DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
              ],
              onChanged: (value) {
                if (value != null) tipo = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final desc = descController.text.trim();
              final cantidad =
                  double.tryParse(cantidadController.text.trim()) ?? 0.0;

              if (desc.isNotEmpty && cantidad > 0) {
                final nuevo = Movimiento(
                  descripcion: desc,
                  cantidad: cantidad,
                  tipo: tipo,
                  fecha: DateTime.now(),
                );
                ref.read(movimientosProvider.notifier).agregarMovimiento(nuevo);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

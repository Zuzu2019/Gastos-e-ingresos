import 'package:gatos_ingresos/database/movimietos_db.dart';
import 'package:riverpod/riverpod.dart';
import '../../../models/movimiento.dart';

final movimientosProvider =
    StateNotifierProvider<MovimientosNotifier, List<Movimiento>>((ref) {
      return MovimientosNotifier();
    });

class MovimientosNotifier extends StateNotifier<List<Movimiento>> {
  MovimientosNotifier() : super([]) {
    cargarMovimientos();
  }

  Future<void> cargarMovimientos() async {
    final movimientos = await MovimientosDB.getMovimientos();
    state = movimientos;
  }

  Future<void> agregarMovimiento(Movimiento movimiento) async {
    await MovimientosDB.insertMovimiento(movimiento);
    await cargarMovimientos();
  }

  Future<void> eliminarMovimiento(int id) async {
    await MovimientosDB.deleteMovimiento(id);
    await cargarMovimientos();
  }

  // (opcional) limpiar todos
  Future<void> limpiarTodo() async {
    await MovimientosDB.clearAll();
    await cargarMovimientos();
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movimiento.dart';

class MovimientosDB {
  static Database? _database;

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movimientos.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movimientos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        cantidad REAL NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL
      )
    ''');
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Insertar un movimiento
  static Future<int> insertMovimiento(Movimiento movimiento) async {
    final db = await database;
    return await db.insert('movimientos', movimiento.toMap());
  }

  // Obtener todos los movimientos
  static Future<List<Movimiento>> getMovimientos() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'movimientos',
      orderBy: 'fecha DESC',
    );

    return result.map((map) => Movimiento.fromMap(map)).toList();
  }

  // Eliminar un movimiento por id
  static Future<int> deleteMovimiento(int id) async {
    final db = await database;
    return await db.delete('movimientos', where: 'id = ?', whereArgs: [id]);
  }

  // (Opcional) Borrar todos los movimientos
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('movimientos');
  }
}

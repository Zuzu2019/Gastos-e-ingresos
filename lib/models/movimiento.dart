class Movimiento {
  final int? id;
  final String tipo; // 'ingreso' o 'gasto'
  final double cantidad; // aquí está el campo 'cantidad'
  final String descripcion;
  final DateTime fecha;

  Movimiento({
    this.id,
    required this.tipo,
    required this.cantidad,
    required this.descripcion,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Movimiento.fromMap(Map<String, dynamic> map) {
    return Movimiento(
      id: map['id'],
      tipo: map['tipo'],
      cantidad: map['cantidad'],
      descripcion: map['descripcion'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}

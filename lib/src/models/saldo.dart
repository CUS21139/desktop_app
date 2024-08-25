class Saldo {
  const Saldo({
    this.id,
    required this.fecha,
    required this.hora,
    required this.createdBy,
    required this.clientes,
    required this.bancos,
    required this.proveedores,
    required this.saldoFinal,
  });

  final int? id;
  final String fecha;
  final String hora;
  final String createdBy;
  final double clientes;
  final double bancos;
  final double proveedores;
  final double saldoFinal;

  factory Saldo.fromJson(Map<String, dynamic> json) => Saldo(
      id: json['id'],
      fecha: json['fecha'],
      hora: json['hora'],
      createdBy: json['created_by'],
      clientes: json['clientes'].toDouble(),
      bancos: json['bancos'].toDouble(),
      proveedores: json['proveedores'].toDouble(),
      saldoFinal: json['saldo_final'].toDouble());

  Map<String, dynamic> toJson() => {
        'id': id,
        'fecha': fecha,
        'hora': hora,
        'created_by': createdBy,
        'clientes': clientes,
        'bancos': bancos,
        'proveedores': proveedores,
        'saldo_final': saldoFinal
      };
}

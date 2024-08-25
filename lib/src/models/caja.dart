class Caja {
  const Caja({
    this.id,
    required this.fecha,
    required this.createdBy,
    required this.closed,
    required this.saldoInicial,
    required this.totalIngresos,
    required this.totalEgresos,
    required this.saldoFinal,
  });

  final int? id;
  final String fecha;
  final String createdBy;
  final int? closed;
  final double saldoInicial;
  final double totalIngresos;
  final double totalEgresos;
  final double saldoFinal;

  factory Caja.fromJson(Map<String, dynamic> json) => Caja(
        id: json['id'],
        fecha: json['fecha'],
        createdBy: json['created_by'],
        closed: json['closed'],
        saldoInicial: json['saldo_inicial'].toDouble(),
        totalIngresos: json['total_ingresos'].toDouble(),
        totalEgresos: json['total_egresos'].toDouble(),
        saldoFinal: json['saldo_final'].toDouble(),
      );

  Caja copyWith({
    int? newClosed,
    double? newSaldoInicial,
    double? newTotalIngresos,
    double? newTotalEgresos,
    double? newSaldoFinal,
  }) =>
      Caja(
        id: id,
        fecha: fecha,
        createdBy: createdBy,
        closed: closed,
        saldoInicial: newSaldoInicial ?? saldoInicial,
        totalIngresos: newTotalIngresos ?? totalIngresos,
        totalEgresos: newTotalEgresos ?? totalEgresos,
        saldoFinal: newSaldoFinal ?? saldoFinal,
      );
}

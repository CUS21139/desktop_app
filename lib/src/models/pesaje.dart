import 'dart:convert';

Pesaje pesajeFromJson(String str) => Pesaje.fromJson(json.decode(str));
String pesajeToJson(Pesaje pesaje) => json.encode(pesaje.toJson());

class Pesaje {
  Pesaje({
    required this.createdAt,
    required this.nroJabas,
    required this.pesoJaba,
    required this.bruto,
    required this.tara,
    required this.neto,
    required this.nroAves,
    required this.promedio,
    required this.importe,
    this.observacion,
  });

  final DateTime createdAt;
  final int nroJabas;
  final double pesoJaba;
  final double bruto;
  final double tara;
  final double neto;
  final int nroAves;
  final double promedio;
  final double importe;
  final String? observacion;

  bool inRange(double min, double max) => min <= promedio && max >= promedio;

  factory Pesaje.fromJson(Map<String, dynamic> json) => Pesaje(
        createdAt: DateTime.parse(json['created_at']),
        nroJabas: json['nro_jabas'],
        pesoJaba: json['peso_jaba'].toDouble(),
        bruto: json['bruto'].toDouble(),
        tara: json['tara'].toDouble(),
        neto: json['neto'].toDouble(),
        nroAves: json['nro_aves'],
        promedio: json['promedio'].toDouble(),
        importe: json['importe'].toDouble(),
        observacion: json['observacion'],
      );

  Map<String, dynamic> toJson() => {
        'created_at': createdAt.toIso8601String(),
        'nro_jabas': nroJabas,
        'peso_jaba': pesoJaba,
        'bruto': bruto,
        'tara': tara,
        'neto': neto,
        'nro_aves': nroAves,
        'promedio': promedio,
        'importe': importe,
        'observacion': observacion,
      };

  Pesaje copyWith({double? newImporte}) => Pesaje(
        createdAt: createdAt,
        nroJabas: nroJabas,
        pesoJaba: pesoJaba,
        bruto: bruto,
        tara: tara,
        neto: neto,
        nroAves: nroAves,
        promedio: promedio,
        importe: newImporte ?? importe,
      );
}
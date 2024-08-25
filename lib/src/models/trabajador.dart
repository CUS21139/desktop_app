import '/src/utils/date_formats.dart';
import './entity.dart';

class Trabajador extends Entity{
  const Trabajador({
    super.id,
    required this.createdAt,
    required this.createdBy,
    required super.nombre,
    required this.zonaCode,
    required this.celular,
    super.estadoCta,
    super.saldo,
    this.sueldoDia = 0,
    required this.password,
  });

  final DateTime createdAt;
  final String createdBy;
  final int? celular;
  final String zonaCode;
  final double sueldoDia;
  final String password;

  String get entityType => 'TR';

  factory Trabajador.fromJson(Map<String, dynamic> json) => Trabajador(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        celular: json['celular'],
        zonaCode: json['zona_code'],
        estadoCta: json['estado_cta'],
        saldo: json['saldo'] != null ? json['saldo'].toDouble() : 0,
        sueldoDia: json['sueldo_dia'] != null ? json['sueldo_dia'].toDouble() : 0,
        password: json['password'] ?? ''
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': dt.format(createdAt),
        'created_by': createdBy,
        'nombre': nombre,
        'celular': celular,
        'zona_code': zonaCode,
        'estado_cta': estadoCta,
        'saldo': saldo,
        'sueldo_dia': sueldoDia,
        'password': password
      };

  Trabajador copyWith({
    String? newNombre,
    int? newCelular,
    String? newZone,
    double? newSaldo,
    double? newSueldo,
    String? newPass,
  }) =>
      Trabajador(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        nombre: newNombre ?? nombre,
        celular: newCelular ?? celular,
        zonaCode: newZone ?? zonaCode,
        estadoCta: estadoCta,
        saldo: newSaldo ?? saldo,
        sueldoDia: newSueldo ?? sueldoDia,
        password: newPass ?? password
      );
}

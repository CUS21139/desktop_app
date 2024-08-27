import './entity.dart';

class Cliente extends Entity{
  const Cliente({
    super.id,
    required this.createdAt,
    required this.createdBy,
    required super.nombre,
    required this.zonaCode,
    required this.celular,
    super.estadoCta,
    super.saldo,
    this.saldoMaximo,
    this.saldoMinimo,
    this.usuario = '',
    this.password = ''
  });

  final DateTime createdAt;
  final String createdBy;
  final String? celular;
  final String zonaCode;
  final double? saldoMaximo;
  final double? saldoMinimo;
  final String usuario;
  final String password;
  
  String get entityType => 'CL';

  bool get inRangeMax {
    if(saldoMaximo == 0){
      return true;
    }
    return saldo! < saldoMaximo!;
  }
  bool get inRangeMin {
    if(saldoMinimo! == 0 ){
      return true;
    }
    return saldo! <= saldoMinimo!;
  }

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        createdBy: json['created_by'],
        nombre: json['nombre'],
        celular: json['celular'],
        zonaCode: json['zona_code'],
        estadoCta: json['estado_cta'],
        saldo: json['saldo'] == null ? 0.0 : json['saldo'].toDouble(),
        saldoMaximo: json['saldo_maximo'] == null ? 0.0 : json['saldo_maximo'].toDouble(),
        saldoMinimo: json['saldo_minimo'] == null ? 0.0 : json['saldo_minimo'].toDouble(),
        usuario: json['usuario'] ?? '',
        password: json['password'] ?? ''
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'created_by': createdBy,
        'nombre': nombre,
        'celular': celular,
        'zona_code': zonaCode,
        'estado_cta': estadoCta,
        'saldo': saldo,
        'saldo_maximo': saldoMaximo,
        'saldo_minimo': saldoMinimo,
        'usuario': usuario,
        'password': password,
      };

  Cliente copyWith(
          {String? newNombre,
          String? newCelular,
          String? newZone,
          double? newSaldo,
          double? newSaldoMaximo,
          double? newSaldoMinimo,
          String? newUsuario,
          String? newPass}) =>
      Cliente(
        id: id,
        createdAt: createdAt,
        createdBy: createdBy,
        nombre: newNombre ?? nombre,
        celular: newCelular ?? celular,
        zonaCode: newZone ?? zonaCode,
        estadoCta: estadoCta,
        saldo: newSaldo ?? saldo,
        saldoMaximo: newSaldoMaximo ?? saldoMaximo,
        saldoMinimo: newSaldoMinimo ?? saldoMinimo,
        usuario: newUsuario ?? usuario,
        password: newPass ?? password,
      );
}
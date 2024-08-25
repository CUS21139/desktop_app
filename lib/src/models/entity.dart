abstract class Entity {
  const Entity({this.id, required this.nombre, this.estadoCta, this.saldo});

  final int? id;
  final String nombre;
  final String? estadoCta;
  final double? saldo;
}
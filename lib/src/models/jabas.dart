class Jaba {
  const Jaba({
    this.id,
    required this.color,
    required this.cantidad,
  });

  final int? id;
  final String color;
  final int cantidad;

  factory Jaba.fromJson(Map<String, dynamic> json) => Jaba(
        id: json['id'],
        color: json['color'],
        cantidad: json['cantidad'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color,
        'cantidad': cantidad,
      };

  Jaba copyWith({String? newColor, int? newCantidad}) => Jaba(
        id: id,
        color: newColor ?? color,
        cantidad: newCantidad ?? cantidad,
      );
}

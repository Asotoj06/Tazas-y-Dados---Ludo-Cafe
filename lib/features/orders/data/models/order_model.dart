import 'order_item_model.dart';

class Order {
  final int id;
  final int mesaId;
  final String estado; // 'abierto', 'pagado'
  final double totalAcumulado;
  final DateTime creadoAt;
  final DateTime? cerradoAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.mesaId,
    required this.estado,
    required this.totalAcumulado,
    required this.creadoAt,
    this.cerradoAt,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = <OrderItem>[];
    if (json['pedidio_items'] != null) {
      itemsList = (json['pedidio_items'] as List)
          .map((i) => OrderItem.fromJson(i))
          .toList();
    }

    return Order(
      id: json['id'],
      mesaId: json['mesa_id'],
      estado: json['estado'] ?? 'abierto',
      totalAcumulado: (json['total_acumulado'] as num?)?.toDouble() ?? 0.0,
      creadoAt: DateTime.parse(json['creado_at']),
      cerradoAt: json['cerrado_at'] != null
          ? DateTime.parse(json['cerrado_at'])
          : null,
      items: itemsList,
    );
  }
}

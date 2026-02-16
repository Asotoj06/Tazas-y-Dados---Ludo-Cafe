class OrderItem {
  final int?
  id; // bigint en DB es int en Dart (o BigInt si es muy grande, pero int suele bastar)
  final int pedidoId;
  final int productoId;
  final String
  productName; // Este campo viene de un join, no directo de la tabla pedidio_items
  final int cantidad;
  final double precioUnitario;

  OrderItem({
    this.id,
    required this.pedidoId,
    required this.productoId,
    required this.productName,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      pedidoId: json['pedido_id'],
      productoId: json['producto_id'],
      productName: json['productos']?['nombre'] ?? 'Producto', // Asumiendo join
      cantidad: json['cantidad'],
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pedido_id': pedidoId,
      'producto_id': productoId,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
    };
  }
}

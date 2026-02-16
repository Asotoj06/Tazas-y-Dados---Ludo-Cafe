class Product {
  final int id;
  final String nombre;
  final double precio;
  final int? categoriaId;

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    this.categoriaId,
  });

  // Factory para crear objeto desde Supabase (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'] as String,
      precio: (json['precio'] as num).toDouble(),
      categoriaId: json['categoria_id'],
    );
  }

  // Convertir a Map para enviar a Supabase (si fuera necesario crear productos desde la app)
  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'precio': precio, 'categoria_id': categoriaId};
  }
}

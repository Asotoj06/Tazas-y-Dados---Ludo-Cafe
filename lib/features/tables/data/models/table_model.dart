class TableModel {
  final int id;
  final String estado; // 'disponible', 'ocupada'

  TableModel({required this.id, required this.estado});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(id: json['id'], estado: json['estado']);
  }

  // Helpers para la UI
  bool get isOccupied => estado == 'ocupada';
  bool get isAvailable => estado == 'disponible';
}

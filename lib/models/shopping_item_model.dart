class ShoppingItemModel {
  final int? id;
  final int userId;
  final String name;
  final String deskripsi;
  final String toko;
  final int quantity;
  final bool isDone;

  ShoppingItemModel({
    this.id,
    required this.userId,
    required this.name,
    required this.deskripsi,
    required this.toko,
    required this.quantity,
    required this.isDone,
  });

  factory ShoppingItemModel.fromMap(Map<String, dynamic> map) {
    return ShoppingItemModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      deskripsi: map['deskripsi'],
      toko: map['Toko'],
      quantity: map['quantity'],
      isDone: map['isDone'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'deskripsi': deskripsi,
      'Toko': toko,
      'quantity': quantity,
      'isDone': isDone ? 1 : 0,
    };
  }
}

//.

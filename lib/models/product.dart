import 'dart:convert';

class Product {
  Product({
    required this.available,
    required this.category,
    required this.name,
    this.picture,
    required this.quantity,
    this.store,
    this.id,
  });

  bool available;
  String category;
  String name;
  String? picture;
  int quantity;
  String? store;
  String? id;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        category: json["category"],
        name: json["name"],
        picture: json["picture"],
        quantity: json["quantity"],
        store: json["store"],
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "category": category,
        "name": name,
        "picture": picture,
        "quantity": quantity,
        "store": store,
      };

  Product copy() => Product(
        available: available,
        category: category,
        name: name,
        quantity: quantity,
        picture: picture,
        store: store,
        id: id,
      );
}

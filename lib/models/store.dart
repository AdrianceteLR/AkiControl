import 'dart:convert';

class Store {
  Store({
    required this.name,
    required this.country,
    this.id,
  });

  String name;
  String country;
  String? id;

  factory Store.fromJson(String str) => Store.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Store.fromMap(Map<String, dynamic> json) => Store(
        name: json["name"],
        country: json["country"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "country": country,
      };

  Store copy() => Store(
        name: name,
        country: country,
        id: id,
      );
}

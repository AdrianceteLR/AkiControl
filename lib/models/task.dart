import 'dart:convert';

class Task {
  Task({
    required this.finish,
    required this.title,
    required this.description,
    this.day,
    this.id,
  });

  bool finish;
  String title;
  String description;
  String? day;
  String? id;

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        finish: json["finish"],
        title: json["title"],
        description: json["description"],
        day: json["day"],
      );

  Map<String, dynamic> toMap() => {
        "finish": finish,
        "title": title,
        "description": description,
        "day": day,
      };

  Task copy() => Task(
        finish: finish,
        title: title,
        description: description,
        day: day,
        id: id,
      );
}

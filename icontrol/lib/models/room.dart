// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Room {
  String id;
  String name;
  String iconPath;
  Room({required this.id, required this.name, required this.iconPath});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'iconPath': iconPath,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      name: map['name'] as String,
      iconPath: map['iconPath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) =>
      Room.fromMap(json.decode(source) as Map<String, dynamic>);
}

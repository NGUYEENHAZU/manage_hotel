/// lib/models/room_model.dart
import 'dart:convert';

class RoomModel {
  final String id;
  final String number;
  final String type;
  final double price;
  final bool isAvailable;
  final List<String> amenities;
  final String imagePath; // Thêm trường imagePath

  RoomModel({
    required this.id,
    required this.number,
    required this.type,
    required this.price,
    required this.isAvailable,
    required this.amenities,
    required this.imagePath,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      number: map['number'] as String,
      type: map['type'] as String,
      price: (map['price'] as num).toDouble(),
      isAvailable: map['isAvailable'] as bool,
      amenities: List<String>.from(map['amenities'] ?? []),
      imagePath: map['imagePath'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'type': type,
      'price': price,
      'isAvailable': isAvailable,
      'amenities': amenities,
      'imagePath': imagePath,
    };
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));
}

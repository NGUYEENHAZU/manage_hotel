///lib\models\booking_model.dart

import 'dart:convert';

class Booking {
  final String id;
  final String roomId;
  final String userEmail;
  final DateTime checkIn;
  final DateTime checkOut;

  Booking({
    required this.id,
    required this.roomId,
    required this.userEmail,
    required this.checkIn,
    required this.checkOut,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as String,
      roomId: map['roomId'] as String,
      userEmail: map['userEmail'] as String,
      checkIn: DateTime.parse(map['checkIn'] as String),
      checkOut: DateTime.parse(map['checkOut'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'userEmail': userEmail,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());
}

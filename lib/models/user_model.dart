/// lib/models/user_model.dart
import 'dart:convert';

class UserModel {
  final String email;
  final String password;
  final String role;
  final String tier; // 'bronze', 'silver', 'gold', 'platinum'

  UserModel({
    required this.email,
    required this.password,
    required this.role,
    this.tier = 'bronze',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] as String,
      tier: map['tier'] as String? ?? 'bronze',
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password, 'role': role, 'tier': tier};
  }

  String toJson() => json.encode(toMap());
}

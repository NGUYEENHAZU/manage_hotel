///lib\repositories\user_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserRepository {
  static const _storageKeyPrefix = 'hotel_user_';

  // Lấy người dùng theo email
  Future<UserModel?> getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('$_storageKeyPrefix$email');
    if (userJson == null) return null;
    return UserModel.fromMap(json.decode(userJson) as Map<String, dynamic>);
  }

  // Lấy tất cả người dùng (dùng khi cần, ví dụ: quản lý)
  Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final userKeys =
        keys.where((key) => key.startsWith(_storageKeyPrefix)).toList();
    final users = <UserModel>[];
    for (var key in userKeys) {
      final userJson = prefs.getString(key);
      if (userJson != null) {
        users.add(
          UserModel.fromMap(json.decode(userJson) as Map<String, dynamic>),
        );
      }
    }
    return users;
  }

  // Thêm người dùng
  Future<void> addUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_storageKeyPrefix${user.email}', user.toJson());
  }

  // Khởi tạo người dùng mẫu
  Future<void> initializeSampleUsers() async {
    final users = await getUsers();
    if (users.isEmpty) {
      final sampleUsers = [
        UserModel(email: 'c@gmail.com', password: '123@Abc', role: 'customer'),
        UserModel(email: 's@gmail.com', password: '123@Abc', role: 'staff'),
        UserModel(email: 'm@gmail.com', password: '123@Abc', role: 'manager'),
      ];
      for (var user in sampleUsers) {
        await addUser(user);
      }
    }
  }
}

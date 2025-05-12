/// lib/services/local_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserToken = 'user_token';
  static const _keyUserRole = 'user_role';
  static const _keyUserEmail = 'user_email';
  static const _keyUserTier = 'user_tier';

  Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserToken, token);
  }

  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserToken);
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserRole, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  Future<void> saveUserTier(String tier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserTier, tier);
  }

  Future<String?> getUserTier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserTier);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

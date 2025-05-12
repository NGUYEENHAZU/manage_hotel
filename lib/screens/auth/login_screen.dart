/// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/local_storage_service.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/custom_app_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  final _storage = LocalStorageService();
  final _userRepo = UserRepository();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);

    try {
      final user = await _userRepo.getUserByEmail(_email);
      if (user != null && user.password == _password) {
        await _storage.saveUserToken('abc123');
        await _storage.saveLoginState(true);
        await _storage.saveUserRole(user.role);
        await _storage.saveUserEmail(user.email); // Lưu email để sử dụng sau
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email hoặc mật khẩu không đúng')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xảy ra lỗi: $e')));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Đăng nhập'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator:
                    (v) => v!.contains('@') ? null : 'Email không hợp lệ',
                onSaved: (v) => _email = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (v) => v!.length >= 6 ? null : 'Tối thiểu 6 ký tự',
                onSaved: (v) => _password = v!,
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submit,
                    child: Text('Đăng nhập'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

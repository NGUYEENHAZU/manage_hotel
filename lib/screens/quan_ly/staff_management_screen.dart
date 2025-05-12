/// lib/screens/quan_ly/staff_management_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../repositories/user_repository.dart';
import '../../models/user_model.dart';

class StaffManagementScreen extends StatefulWidget {
  @override
  _StaffManagementScreenState createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final _userRepo = UserRepository();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _addStaff() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    await _userRepo.addUser(
      UserModel(email: _email, password: _password, role: 'staff'),
    );
    setState(() {});
  }

  void _showPayrollDialog() {
    String passwordInput = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Xác nhận phát lương'),
            content: TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Nhập mật khẩu'),
              onChanged: (value) => passwordInput = value,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Trở lại'),
              ),
              TextButton(
                onPressed: () async {
                  final user = await _userRepo.getUserByEmail(
                    'm@gmail.com',
                  ); // Giả định email quản lý
                  if (passwordInput == user?.password) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Đã phát lương')));
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Mật khẩu sai')));
                  }
                },
                child: Text('Xác nhận'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Quản lý nhân viên'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<List<UserModel>>(
              future: _userRepo.getUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final staff =
                    snapshot.data!.where((u) => u.role == 'staff').toList();
                return Expanded(
                  child: ListView.builder(
                    itemCount: staff.length,
                    itemBuilder: (context, index) {
                      final user = staff[index];
                      return ListTile(
                        title: Text(user.email),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _userRepo.addUser(
                              UserModel(
                                email: user.email,
                                password: user.password,
                                role: 'deleted',
                              ),
                            ); // Xóa bằng cách đánh dấu
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Email nhân viên'),
                      validator:
                          (v) => v!.contains('@') ? null : 'Email không hợp lệ',
                      onSaved: (v) => _email = v!,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: _addStaff, child: Text('Thêm')),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPayrollDialog,
              child: Text('Phát lương'),
            ),
          ],
        ),
      ),
    );
  }
}

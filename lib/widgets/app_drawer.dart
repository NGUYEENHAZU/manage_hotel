/// lib\services\local_storage_service.dart

import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageService>(context);
    return FutureBuilder<String?>(
      future: storage.getUserRole(),
      builder: (context, snapshot) {
        final role = snapshot.data ?? 'customer';
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              if (role == 'customer') ...[
                ListTile(
                  title: Text('Trang chủ'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: Text('Lịch sử đặt phòng'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/history');
                  },
                ),
              ],
              if (role == 'staff') ...[
                ListTile(
                  title: Text('Dashboard Nhân viên'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
              if (role == 'manager') ...[
                ListTile(
                  title: Text('Dashboard Quản lý'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
              ListTile(
                title: Text('Đăng xuất'),
                onTap: () async {
                  await storage.clearAll();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

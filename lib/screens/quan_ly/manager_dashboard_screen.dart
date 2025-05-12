/// lib/screens/quan_ly/manager_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import 'income_screen.dart';
import 'staff_management_screen.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard Quản lý'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng Quản lý',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Thu nhập tuần này'),
                trailing: Text('₫5,000,000'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => IncomeScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.people),
                title: Text('Quản lý nhân viên'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StaffManagementScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

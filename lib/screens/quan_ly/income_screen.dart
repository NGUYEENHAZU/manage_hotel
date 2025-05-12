/// lib/screens/quan_ly/income_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  String filter = 'week'; // 'week', 'month'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Thu nhập chi tiết'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: filter,
              items: [
                DropdownMenuItem(value: 'week', child: Text('Tuần này')),
                DropdownMenuItem(value: 'month', child: Text('Tháng này')),
              ],
              onChanged: (value) {
                setState(() => filter = value!);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Tổng thu nhập: ₫${filter == 'week' ? '5,000,000' : '20,000,000'}',
            ),
            // Thêm logic thực tế để tính thu nhập từ bookings
          ],
        ),
      ),
    );
  }
}

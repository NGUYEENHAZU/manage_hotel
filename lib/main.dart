///lib\main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/local_storage_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/khach_hang/customer_home_screen.dart';
import 'screens/khach_hang/booking_history_screen.dart';
import 'screens/nhan_vien/staff_dashboard_screen.dart';
import 'screens/quan_ly/manager_dashboard_screen.dart';
import 'repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  final storage = LocalStorageService();
  final userRepo = UserRepository();
  await userRepo.initializeSampleUsers();
  bool isLoggedIn = await storage.getLoginState();

  runApp(
    MultiProvider(
      providers: [Provider<LocalStorageService>.value(value: storage)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn ? '/' : '/login',
        routes: {
          '/login': (_) => LoginScreen(),
          '/': (_) => MainApp(),
          '/history': (_) => BookingHistoryScreen(),
        },
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageService>(context);
    return FutureBuilder<String?>(
      future: storage.getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final role =
            snapshot.data ??
            'customer'; // Mặc định là customer nếu không có role
        Widget homeScreen;
        switch (role) {
          case 'customer':
            homeScreen = CustomerHomeScreen();
            break;
          case 'staff':
            homeScreen = StaffDashboardScreen();
            break;
          case 'manager':
            homeScreen = ManagerDashboardScreen();
            break;
          default:
            homeScreen = CustomerHomeScreen(); // Fallback
        }
        return Scaffold(body: homeScreen);
      },
    );
  }
}

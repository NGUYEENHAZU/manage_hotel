// lib/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.onTabSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabSelected,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Khách'),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Nhân viên'),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Quản lý',
        ),
      ],
    );
  }
}

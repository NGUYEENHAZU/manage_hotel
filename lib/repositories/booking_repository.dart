/// lib\repositories\booking_repository.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';

class BookingRepository {
  static const _storageKey = 'hotel_bookings';

  Future<List<Booking>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];
    return stored
        .map((s) => Booking.fromMap(json.decode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];
    list.add(booking.toJson());
    await prefs.setStringList(_storageKey, list);
  }

  Future<void> removeBooking(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];
    list.removeWhere((s) {
      final map = json.decode(s) as Map<String, dynamic>;
      return map['id'] == id;
    });
    await prefs.setStringList(_storageKey, list);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

/// lib\repositories\room_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/room_model.dart';

class RoomRepository {
  static const _storageKey = 'hotel_rooms';

  Future<List<RoomModel>> getRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];
    return stored
        .map((s) => RoomModel.fromMap(json.decode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addRoom(RoomModel room) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];
    list.add(room.toJson());
    await prefs.setStringList(_storageKey, list);
  }
}

/// lib/screens/khach_hang/room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/room_model.dart';
import '../../models/booking_model.dart';
import '../../repositories/booking_repository.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/custom_app_bar.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomModel room;
  const RoomDetailScreen({Key? key, required this.room}) : super(key: key);

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  DateTime? _checkIn, _checkOut;
  bool _saving = false;
  final _repo = BookingRepository();

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkIn = picked.start;
        _checkOut = picked.end;
      });
    }
  }

  Future<bool> _isRoomAvailable() async {
    final bookings = await _repo.getBookings();
    return !bookings.any(
      (b) =>
          b.roomId == widget.room.id &&
          _checkIn!.isBefore(b.checkOut) &&
          _checkOut!.isAfter(b.checkIn),
    );
  }

  Future<void> _book() async {
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng chọn ngày')));
      return;
    }
    if (!await _isRoomAvailable()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Phòng không trống')));
      return;
    }
    setState(() => _saving = true);
    final storage = Provider.of<LocalStorageService>(context, listen: false);
    final userEmail = await storage.getUserEmail();
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: widget.room.id,
      userEmail: userEmail!,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
    );
    await _repo.addBooking(booking);
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đặt phòng thành công!')));
    Navigator.pop(context);
  }

  double _getDiscountedPrice(String tier) {
    switch (tier) {
      case 'silver':
        return widget.room.price * 0.98;
      case 'gold':
        return widget.room.price * 0.95;
      case 'platinum':
        return widget.room.price * 0.90;
      default:
        return widget.room.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageService>(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Chi tiết Phòng ${widget.room.number}'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<String?>(
          future: storage.getUserTier(),
          builder: (context, snapshot) {
            final tier = snapshot.data ?? 'bronze';
            final price = _getDiscountedPrice(tier);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.room.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text('Loại: ${widget.room.type}'),
                Text('Giá: ₫${price.toStringAsFixed(0)} / đêm (Hạng $tier)'),
                Text('Tiện nghi: ${widget.room.amenities.join(', ')}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickDates,
                  child: Text(
                    _checkIn == null
                        ? 'Chọn ngày'
                        : 'Từ ${_checkIn!.toLocal()} đến ${_checkOut!.toLocal()}',
                  ),
                ),
                SizedBox(height: 20),
                _saving
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: _book,
                      child: Text('Xác nhận đặt phòng'),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

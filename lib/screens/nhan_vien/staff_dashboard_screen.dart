/// lib/screens/nhan_vien/staff_dashboard_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../repositories/room_repository.dart';
import '../../repositories/booking_repository.dart';
import '../../models/room_model.dart';
import '../../models/booking_model.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({Key? key}) : super(key: key);

  @override
  _StaffDashboardScreenState createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  final _roomRepo = RoomRepository();
  final _bookingRepo = BookingRepository();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 30), (_) => _checkOverdue());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkOverdue() async {
    final bookings = await _bookingRepo.getBookings();
    for (var booking in bookings) {
      if (DateTime.now().isAfter(booking.checkOut) &&
          !(await _roomRepo.getRooms()).any(
            (r) => r.id == booking.roomId && r.isAvailable,
          )) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phòng ${booking.roomId} quá hạn!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard Nhân viên'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách phòng:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<RoomModel>>(
                future: _roomRepo.getRooms(),
                builder: (context, roomSnapshot) {
                  if (!roomSnapshot.hasData) return CircularProgressIndicator();
                  final rooms = roomSnapshot.data!;
                  return FutureBuilder<List<Booking>>(
                    future: _bookingRepo.getBookings(),
                    builder: (context, bookingSnapshot) {
                      if (!bookingSnapshot.hasData)
                        return CircularProgressIndicator();
                      final bookings = bookingSnapshot.data!;
                      return ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          final room = rooms[index];
                          final booking = bookings.firstWhere(
                            (b) => b.roomId == room.id,
                            orElse: () => null as Booking,
                          );
                          return ListTile(
                            title: Text('Phòng ${room.number}'),
                            subtitle: Text(
                              booking != null
                                  ? 'Đã đặt đến ${booking.checkOut}'
                                  : 'Trống',
                            ),
                            trailing:
                                booking != null
                                    ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.check),
                                          onPressed: () async {
                                            // Xác nhận thanh toán
                                            await _bookingRepo.addBooking(
                                              booking,
                                            ); // Giả định đã thanh toán
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('Đã xác nhận'),
                                              ),
                                            );
                                            setState(() {});
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () async {
                                            await _bookingRepo.removeBooking(
                                              booking.id,
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Đã hủy, phạt 20%',
                                                ),
                                              ),
                                            );
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    )
                                    : null,
                          );
                        },
                      );
                    },
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

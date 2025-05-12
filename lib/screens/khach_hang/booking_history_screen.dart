/// lib/screens/khach_hang/booking_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../repositories/booking_repository.dart';
import '../../models/booking_model.dart';
import '../../services/local_storage_service.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final _repo = BookingRepository();

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageService>(context);
    return FutureBuilder<String?>(
      future: storage.getUserRole(),
      builder: (context, roleSnapshot) {
        if (roleSnapshot.hasData && roleSnapshot.data != 'customer') {
          return Scaffold(
            body: Center(child: Text('Bạn không có quyền truy cập')),
          );
        }
        return Scaffold(
          appBar: CustomAppBar(title: 'Lịch sử đặt phòng'),
          body: FutureBuilder<String?>(
            future: storage.getUserEmail(),
            builder: (context, emailSnapshot) {
              if (!emailSnapshot.hasData)
                return Center(child: CircularProgressIndicator());
              final userEmail = emailSnapshot.data!;
              return FutureBuilder<List<Booking>>(
                future: _repo.getBookings(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  final bookings =
                      snapshot.data!
                          .where((b) => b.userEmail == userEmail)
                          .toList();
                  if (bookings.isEmpty)
                    return Center(child: Text('Chưa có dữ liệu'));
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return ListTile(
                        title: Text('Phòng ID: ${booking.roomId}'),
                        subtitle: Text(
                          'Từ ${booking.checkIn.toLocal()} đến ${booking.checkOut.toLocal()}',
                        ),
                        trailing:
                            booking.checkIn.isAfter(DateTime.now())
                                ? IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () async {
                                    await _repo.removeBooking(booking.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Đã hủy, hoàn 80%'),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                )
                                : null,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

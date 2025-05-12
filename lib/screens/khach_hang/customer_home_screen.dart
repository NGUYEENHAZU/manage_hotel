/// lib/screens/khach_hang/customer_home_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../models/room_model.dart';
import '../../repositories/room_repository.dart';
import 'room_detail_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  final _roomRepo = RoomRepository();

  CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Trang Chủ Khách'),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng bạn!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Danh sách phòng:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<RoomModel>>(
                future: _roomRepo.getRooms(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final rooms =
                      snapshot.data!
                          .where((room) => room.isAvailable)
                          .toList(); // Chỉ hiển thị phòng trống
                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                            room.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text('Phòng ${room.number} (${room.type})'),
                          subtitle: Text(
                            'Giá: ₫${room.price.toStringAsFixed(0)} / đêm',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RoomDetailScreen(room: room),
                                ),
                              );
                            },
                            child: Text('Đặt ngay'),
                          ),
                        ),
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

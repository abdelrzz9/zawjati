import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';

class NotificationsRemoteDataSource {
  final DioClient client;

  NotificationsRemoteDataSource({required this.client});

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await client.get(
      EndPoints.notifications,
      requiresAuth: true,
    );
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<void> markRead(String notificationId) async {
    await client.post(
      EndPoints.notificationsRead,
      data: {'notification_id': notificationId},
      requiresAuth: true,
    );
  }

  Future<void> markAllRead() async {
    await client.post(
      EndPoints.notificationsRead,
      data: {'mark_all': true},
      requiresAuth: true,
    );
  }
}

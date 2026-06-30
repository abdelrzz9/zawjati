import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';

class DashboardRemoteDataSource {
  final DioClient client;

  DashboardRemoteDataSource({required this.client});

  Future<Map<String, dynamic>> getMetricsSummary() async {
    final response = await client.get(
      EndPoints.metricsSummary,
      requiresAuth: true,
    );
    return response.data as Map<String, dynamic>;
  }
}

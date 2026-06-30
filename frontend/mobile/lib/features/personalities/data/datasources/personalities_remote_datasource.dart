import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';

class PersonalitiesRemoteDataSource {
  final DioClient client;

  PersonalitiesRemoteDataSource({required this.client});

  Future<List<dynamic>> getPersonalities() async {
    final response = await client.get(
      EndPoints.personalities,
      requiresAuth: true,
    );
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['personalities'] is List) {
      return data['personalities'] as List<dynamic>;
    }
    return [];
  }
}

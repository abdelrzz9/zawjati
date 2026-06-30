import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';

class ProfileRemoteDataSource {
  final DioClient client;

  ProfileRemoteDataSource({required this.client});

  Future<Map<String, dynamic>> getProfile(String userId) async {
    final response = await client.get(
      EndPoints.profileById(userId),
      requiresAuth: true,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final response = await client.post(
      EndPoints.profileById(userId),
      data: data,
      requiresAuth: true,
    );
    return response.data as Map<String, dynamic>;
  }
}

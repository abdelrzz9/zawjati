import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSource({required this.client});

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      EndPoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await client.post(
      EndPoints.register,
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await client.post(
      EndPoints.refresh,
      data: {
        'refresh_token': refreshToken,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await client.post(
      EndPoints.logout,
      requiresAuth: true,
    );
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await client.get(
      EndPoints.me,
      requiresAuth: true,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteAccount() async {
    await client.delete(
      EndPoints.deleteAccount,
      requiresAuth: true,
    );
  }

  Future<Map<String, dynamic>> googleLogin() async {
    final response = await client.post(EndPoints.googleLogin);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> appleLogin() async {
    final response = await client.post(EndPoints.appleLogin);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> githubLogin() async {
    final response = await client.post(EndPoints.githubLogin);
    return response.data as Map<String, dynamic>;
  }
}

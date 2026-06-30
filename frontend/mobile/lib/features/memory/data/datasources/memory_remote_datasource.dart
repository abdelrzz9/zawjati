import 'package:zawjati_mobile/core/network/dio_client.dart';
import 'package:zawjati_mobile/features/memory/domain/entities/memory.dart';
import '../models/memory_model.dart';

class MemoryRemoteDataSource {
  final DioClient client;

  MemoryRemoteDataSource({required this.client});

  Future<List<MemoryModel>> getMemories(
    String userId, {
    MemoryCategory? category,
    int? minImportance,
  }) async {
    final queryParams = <String, dynamic>{
      'user_id': userId,
    };
    if (category != null) {
      queryParams['category'] = category.toJson();
    }
    if (minImportance != null) {
      queryParams['min_importance'] = minImportance;
    }
    final response = await client.get(
      '/api/memories',
      queryParameters: queryParams,
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => MemoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MemoryModel>> searchMemories(
    String userId,
    String query,
  ) async {
    final response = await client.get(
      '/api/memories/search',
      queryParameters: {
        'q': query,
        'user_id': userId,
      },
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => MemoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteMemory(String id) async {
    await client.delete('/api/memories/$id');
  }

  Future<void> updateMemory(String id, Map<String, dynamic> data) async {
    await client.put('/api/memories/$id', data: data);
  }
}

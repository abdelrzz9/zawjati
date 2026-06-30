import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';

class DocumentsRemoteDataSource {
  final DioClient client;

  DocumentsRemoteDataSource({required this.client});

  Future<List<Map<String, dynamic>>> getDocuments() async {
    final response = await client.get(
      EndPoints.documents,
      requiresAuth: true,
    );
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> uploadDocument(
    String filePath,
    String filename,
  ) async {
    final response = await client.postMultipart(
      EndPoints.documentsUpload,
      files: [
        {
          'field': 'file',
          'path': filePath,
          'filename': filename,
        },
      ],
      requiresAuth: true,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteDocument(String id) async {
    await client.delete(
      EndPoints.documentById(id),
      requiresAuth: true,
    );
  }

  Future<Map<String, dynamic>> getDocument(String id) async {
    final response = await client.get(
      EndPoints.documentById(id),
      requiresAuth: true,
    );
    return response.data as Map<String, dynamic>;
  }
}

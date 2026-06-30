import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/documents/domain/entities/user_document.dart';
import 'package:zawjati_mobile/features/documents/domain/usecases/get_documents_usecase.dart';
import 'package:zawjati_mobile/features/documents/domain/usecases/upload_document_usecase.dart';
import 'package:zawjati_mobile/features/documents/presentation/bloc/documents_bloc.dart';

class MockGetDocumentsUseCase extends Mock implements GetDocumentsUseCase {}
class MockUploadDocumentUseCase extends Mock implements UploadDocumentUseCase {}

void main() {
  late MockGetDocumentsUseCase mockGetDocuments;
  late MockUploadDocumentUseCase mockUploadDocument;
  late DocumentsBloc documentsBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(UploadDocumentParams(filePath: '', filename: ''));
  });

  final testDocuments = <UserDocument>[
    UserDocument(
      id: 'doc-1',
      filename: 'notes.txt',
      type: 'text/plain',
      size: 1024,
      status: DocumentStatus.ready,
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  setUp(() {
    mockGetDocuments = MockGetDocumentsUseCase();
    mockUploadDocument = MockUploadDocumentUseCase();
    documentsBloc = DocumentsBloc(
      getDocumentsUseCase: mockGetDocuments,
      uploadDocumentUseCase: mockUploadDocument,
    );
  });

  tearDown(() {
    documentsBloc.close();
  });

  group('DocumentsBloc', () {
    blocTest<DocumentsBloc, DocumentsState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetDocuments(any()))
            .thenAnswer((_) async => Right(testDocuments));
        return documentsBloc;
      },
      act: (bloc) => bloc.add(LoadDocuments()),
      expect: () => [
        DocumentsLoading(),
        DocumentsLoaded(documents: testDocuments),
      ],
    );

    blocTest<DocumentsBloc, DocumentsState>(
      'handles upload success',
      build: () {
        when(() => mockUploadDocument(any()))
            .thenAnswer((_) async => Right(UserDocument(
              id: 'doc-2',
              filename: 'test.pdf',
              type: 'application/pdf',
              size: 2048,
              status: DocumentStatus.ready,
              createdAt: DateTime(2024, 1, 2),
            )));
        when(() => mockGetDocuments(any()))
            .thenAnswer((_) async => Right(testDocuments));
        return documentsBloc;
      },
      seed: () => DocumentsLoaded(documents: testDocuments),
      act: (bloc) => bloc.add(UploadDocument(
        filePath: '/tmp/test.pdf',
        filename: 'test.pdf',
      )),
      expect: () => [
        isA<DocumentsLoaded>().having(
          (s) => s.isUploading, 'uploading', true,
        ),
        DocumentsLoading(),
        DocumentsLoaded(documents: testDocuments),
      ],
    );

    blocTest<DocumentsBloc, DocumentsState>(
      'handles upload failure',
      build: () {
        when(() => mockUploadDocument(any()))
            .thenAnswer((_) async => Left(ServerFailure('Upload failed', 500)));
        return documentsBloc;
      },
      seed: () => DocumentsLoaded(documents: testDocuments),
      act: (bloc) => bloc.add(UploadDocument(
        filePath: '/tmp/test.pdf',
        filename: 'test.pdf',
      )),
      expect: () => [
        isA<DocumentsLoaded>().having(
          (s) => s.isUploading, 'uploading', true,
        ),
        isA<DocumentsLoaded>().having(
          (s) => s.isUploading, 'not uploading', false,
        ),
      ],
    );
  });
}

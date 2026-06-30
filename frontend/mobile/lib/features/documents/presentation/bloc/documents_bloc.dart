import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../../domain/entities/user_document.dart';
import '../../domain/usecases/get_documents_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';

abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentsEvent {}

class UploadDocument extends DocumentsEvent {
  final String filePath;
  final String filename;
  const UploadDocument({required this.filePath, required this.filename});

  @override
  List<Object?> get props => [filePath, filename];
}

class DeleteDocument extends DocumentsEvent {
  final String documentId;
  const DeleteDocument(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

abstract class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object?> get props => [];
}

class DocumentsInitial extends DocumentsState {}

class DocumentsLoading extends DocumentsState {}

class DocumentsLoaded extends DocumentsState {
  final List<UserDocument> documents;
  final bool isUploading;

  const DocumentsLoaded({
    required this.documents,
    this.isUploading = false,
  });

  DocumentsLoaded copyWith({
    List<UserDocument>? documents,
    bool? isUploading,
  }) {
    return DocumentsLoaded(
      documents: documents ?? this.documents,
      isUploading: isUploading ?? this.isUploading,
    );
  }

  @override
  List<Object?> get props => [documents, isUploading];
}

class DocumentsError extends DocumentsState {
  final String message;
  const DocumentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final GetDocumentsUseCase getDocumentsUseCase;
  final UploadDocumentUseCase uploadDocumentUseCase;

  DocumentsBloc({
    required this.getDocumentsUseCase,
    required this.uploadDocumentUseCase,
  }) : super(DocumentsInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<UploadDocument>(_onUploadDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(DocumentsLoading());
    final result = await getDocumentsUseCase(NoParams());
    result.fold(
      (failure) => emit(DocumentsError(failure.userFriendlyMessage)),
      (documents) => emit(DocumentsLoaded(documents: documents)),
    );
  }

  Future<void> _onUploadDocument(
    UploadDocument event,
    Emitter<DocumentsState> emit,
  ) async {
    if (state is DocumentsLoaded) {
      emit((state as DocumentsLoaded).copyWith(isUploading: true));
    }
    final result = await uploadDocumentUseCase(
      UploadDocumentParams(
        filePath: event.filePath,
        filename: event.filename,
      ),
    );
    result.fold(
      (failure) {
        if (state is DocumentsLoaded) {
          emit((state as DocumentsLoaded).copyWith(isUploading: false));
        }
      },
      (_) {
        add(LoadDocuments());
      },
    );
  }

  Future<void> _onDeleteDocument(
    DeleteDocument event,
    Emitter<DocumentsState> emit,
  ) async {
    if (state is DocumentsLoaded) {
      final filtered = (state as DocumentsLoaded)
          .documents
          .where((d) => d.id != event.documentId)
          .toList();
      emit((state as DocumentsLoaded).copyWith(documents: filtered));
    }
  }
}

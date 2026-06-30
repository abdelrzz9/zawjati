import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/features/memory/domain/entities/memory.dart';
import 'package:zawjati_mobile/features/memory/domain/usecases/get_memories_usecase.dart';
import 'package:zawjati_mobile/features/memory/domain/usecases/delete_memory_usecase.dart';
import 'package:zawjati_mobile/features/memory/domain/usecases/search_memories_usecase.dart';
import 'package:zawjati_mobile/features/memory/presentation/bloc/memory_bloc.dart';

class MockGetMemoriesUseCase extends Mock implements GetMemoriesUseCase {}
class MockDeleteMemoryUseCase extends Mock implements DeleteMemoryUseCase {}
class MockSearchMemoriesUseCase extends Mock implements SearchMemoriesUseCase {}

void main() {
  late MockGetMemoriesUseCase mockGetMemories;
  late MockDeleteMemoryUseCase mockDeleteMemory;
  late MockSearchMemoriesUseCase mockSearchMemories;
  late MemoryBloc memoryBloc;

  setUpAll(() {
    registerFallbackValue(GetMemoriesParams(userId: '', category: null, minImportance: null));
    registerFallbackValue(DeleteMemoryParams(id: ''));
    registerFallbackValue(SearchMemoriesParams(userId: '', query: ''));
  });

  final testMemories = <Memory>[
    Memory(
      id: 'mem-1',
      content: 'User likes coffee',
      userId: 'user-1',
      category: MemoryCategory.preference,
      importance: 7,
      timestamp: DateTime(2024, 1, 1),
    ),
  ];

  setUp(() {
    mockGetMemories = MockGetMemoriesUseCase();
    mockDeleteMemory = MockDeleteMemoryUseCase();
    mockSearchMemories = MockSearchMemoriesUseCase();
    memoryBloc = MemoryBloc(
      getMemoriesUseCase: mockGetMemories,
      deleteMemoryUseCase: mockDeleteMemory,
      searchMemoriesUseCase: mockSearchMemories,
    );
  });

  tearDown(() {
    memoryBloc.close();
  });

  group('MemoryBloc', () {
    blocTest<MemoryBloc, MemoryState>(
      'emits [Loading, Loaded] when memories load successfully',
      build: () {
        when(() => mockGetMemories(any()))
            .thenAnswer((_) async => Right(testMemories));
        return memoryBloc;
      },
      act: (bloc) => bloc.add(LoadMemories(userId: 'user-1')),
      expect: () => [
        MemoryLoading(),
        MemoryLoaded(memories: testMemories),
      ],
    );

    blocTest<MemoryBloc, MemoryState>(
      'emits [Loading, Error] when memories fail to load',
      build: () {
        when(() => mockGetMemories(any()))
            .thenAnswer((_) async => Left(ServerFailure('Error', 500)));
        return memoryBloc;
      },
      act: (bloc) => bloc.add(LoadMemories(userId: 'user-1')),
      expect: () => [
        MemoryLoading(),
        isA<MemoryError>(),
      ],
    );

    blocTest<MemoryBloc, MemoryState>(
      'removes memory on DeleteMemory',
      build: () {
        when(() => mockDeleteMemory(any()))
            .thenAnswer((_) async => Right<Failure, void>(null));
        return memoryBloc;
      },
      seed: () => MemoryLoaded(memories: testMemories),
      act: (bloc) { bloc.add(const DeleteMemory(id: 'mem-1')); },
      expect: () => [
        isA<MemoryLoaded>().having(
          (s) => s.memories.length,
          'memories count',
          0,
        ),
      ],
    );

    test('returns search results', () async {
      when(() => mockGetMemories(any()))
          .thenAnswer((_) async => Right(testMemories));
      when(() => mockSearchMemories(any()))
          .thenAnswer((_) async => Right(testMemories));

      memoryBloc.add(LoadMemories(userId: 'user-1'));
      await Future.delayed(Duration.zero);
      memoryBloc.add(const SearchMemories(query: 'coffee'));
      await Future.delayed(Duration.zero);

      expect(memoryBloc.state, isA<MemoryLoaded>());
    });
  });
}

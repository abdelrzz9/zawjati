import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/personalities/domain/entities/personality.dart';
import 'package:zawjati_mobile/features/personalities/domain/usecases/get_personalities_usecase.dart';
import 'package:zawjati_mobile/features/personalities/presentation/bloc/personalities_bloc.dart';

class MockGetPersonalitiesUseCase extends Mock
    implements GetPersonalitiesUseCase {}

void main() {
  late MockGetPersonalitiesUseCase mockGetPersonalities;
  late PersonalitiesBloc personalitiesBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  final testPersonalities = <Personality>[
    const Personality(
      id: 'wife',
      name: 'Wife',
      description: 'Warm and loving',
      category: 'companion',
      isCustom: false,
    ),
    const Personality(
      id: 'friend',
      name: 'Friend',
      description: 'Casual and supportive',
      category: 'friend',
      isCustom: false,
    ),
  ];

  setUp(() {
    mockGetPersonalities = MockGetPersonalitiesUseCase();
    personalitiesBloc = PersonalitiesBloc(
      getPersonalitiesUseCase: mockGetPersonalities,
    );
  });

  tearDown(() {
    personalitiesBloc.close();
  });

  group('PersonalitiesBloc', () {
    blocTest<PersonalitiesBloc, PersonalitiesState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetPersonalities(any()))
            .thenAnswer((_) async => Right(testPersonalities));
        return personalitiesBloc;
      },
      act: (bloc) => bloc.add(GetPersonalitiesEvent()),
      expect: () => [
        PersonalitiesLoading(),
        PersonalitiesLoaded(testPersonalities, null),
      ],
    );

    blocTest<PersonalitiesBloc, PersonalitiesState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetPersonalities(any()))
            .thenAnswer((_) async => Left(ServerFailure('Error', 500)));
        return personalitiesBloc;
      },
      act: (bloc) => bloc.add(GetPersonalitiesEvent()),
      expect: () => [
        PersonalitiesLoading(),
        isA<PersonalitiesError>(),
      ],
    );
  });
}

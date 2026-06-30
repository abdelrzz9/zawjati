import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/features/profile/domain/entities/profile.dart';
import 'package:zawjati_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:zawjati_mobile/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:zawjati_mobile/features/profile/presentation/bloc/profile_bloc.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  late MockGetProfileUseCase mockGet;
  late MockUpdateProfileUseCase mockUpdate;
  late ProfileBloc bloc;

  setUpAll(() {
    registerFallbackValue(GetProfileParams(userId: ''));
    registerFallbackValue(UpdateProfileParams(
      userId: '',
      profile: const UserProfile(userId: '', nickname: '', relationshipType: '', personality: '', language: ''),
    ));
  });

  final testProfile = const UserProfile(
    userId: 'user-1',
    nickname: 'Test User',
    relationshipType: 'companion',
    personality: 'assistant',
    language: 'en',
  );

  setUp(() {
    mockGet = MockGetProfileUseCase();
    mockUpdate = MockUpdateProfileUseCase();
    bloc = ProfileBloc(
      getProfileUseCase: mockGet,
      updateProfileUseCase: mockUpdate,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ProfileBloc', () {
    blocTest<ProfileBloc, ProfileState>(
      'loads profile',
      build: () {
        when(() => mockGet(any()))
            .thenAnswer((_) async => Right(testProfile));
        return bloc;
      },
      act: (b) => b.add(GetProfileEvent(userId: 'user-1')),
      expect: () => [
        ProfileLoading(),
        ProfileLoaded(testProfile),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'updates profile',
      build: () {
        when(() => mockUpdate(any()))
            .thenAnswer((_) async => Right(testProfile));
        return bloc;
      },
      seed: () => ProfileLoaded(testProfile),
      act: (b) => b.add(UpdateProfileEvent(userId: 'user-1', profile: testProfile)),
      expect: () => [
        ProfileLoading(),
        isA<ProfileLoaded>(),
      ],
    );
  });
}

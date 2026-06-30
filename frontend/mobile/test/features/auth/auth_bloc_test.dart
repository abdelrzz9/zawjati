import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/auth/domain/entities/user.dart';
import 'package:zawjati_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:zawjati_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:zawjati_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:zawjati_mobile/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:zawjati_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zawjati_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:zawjati_mobile/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockCheckAuthUseCase extends Mock implements CheckAuthUseCase {}

void main() {
  late MockLoginUseCase mockLogin;
  late MockRegisterUseCase mockRegister;
  late MockLogoutUseCase mockLogout;
  late MockCheckAuthUseCase mockCheckAuth;
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(const RegisterParams(email: '', password: '', name: ''));
    registerFallbackValue(NoParams());
  });

  const testUser = User(
    id: 'user-1',
    email: 'test@test.com',
    name: 'Test User',
  );

  setUp(() {
    mockLogin = MockLoginUseCase();
    mockRegister = MockRegisterUseCase();
    mockLogout = MockLogoutUseCase();
    mockCheckAuth = MockCheckAuthUseCase();
    authBloc = AuthBloc(
      loginUseCase: mockLogin,
      registerUseCase: mockRegister,
      logoutUseCase: mockLogout,
      checkAuthUseCase: mockCheckAuth,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Authenticated] when login succeeds',
      build: () {
        when(() => mockLogin(any()))
            .thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        email: 'test@test.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Error] when login fails',
      build: () {
        when(() => mockLogin(any()))
            .thenAnswer((_) async => Left(ServerFailure('Invalid credentials', 401)));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        email: 'wrong@test.com',
        password: 'wrong',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Authenticated] when register succeeds',
      build: () {
        when(() => mockRegister(any()))
            .thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterRequested(
        name: 'Test User',
        email: 'test@test.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits Unauthenticated when logout succeeds',
      build: () {
        when(() => mockLogout(any()))
            .thenAnswer((_) async => Right<Failure, void>(null));
        return authBloc;
      },
      act: (bloc) { bloc.add(const LogoutRequested()); },
      expect: () => [
        const AuthLoading(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits Authenticated when checkAuth succeeds',
      build: () {
        when(() => mockCheckAuth(any()))
            .thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    test('initial state is AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });
  });
}

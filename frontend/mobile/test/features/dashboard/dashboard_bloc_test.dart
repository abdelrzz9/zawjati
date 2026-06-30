import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/dashboard/domain/entities/dashboard_metrics.dart';
import 'package:zawjati_mobile/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:zawjati_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

void main() {
  late MockGetDashboardUseCase mockGetDashboard;
  late DashboardBloc dashboardBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  final testMetrics = DashboardMetrics(
    totalConversations: 42,
    totalMessages: 1024,
    totalMemories: 86,
  );

  setUp(() {
    mockGetDashboard = MockGetDashboardUseCase();
    dashboardBloc = DashboardBloc(getDashboardUseCase: mockGetDashboard);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  group('DashboardBloc', () {
    blocTest<DashboardBloc, DashboardState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetDashboard(any()))
            .thenAnswer((_) async => Right(testMetrics));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadDashboard()),
      expect: () => [
        DashboardLoading(),
        DashboardLoaded(metrics: testMetrics),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetDashboard(any()))
            .thenAnswer((_) async => Left(ServerFailure('Error', 500)));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadDashboard()),
      expect: () => [
        DashboardLoading(),
        isA<DashboardError>(),
      ],
    );
  });
}

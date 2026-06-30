import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/dashboard_metrics.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase implements UseCase<DashboardMetrics, NoParams> {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardMetrics>> call(NoParams params) {
    return repository.getMetricsSummary();
  }
}

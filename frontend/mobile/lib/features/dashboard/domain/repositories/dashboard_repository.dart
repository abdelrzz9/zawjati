import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../entities/dashboard_metrics.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardMetrics>> getMetricsSummary();
}

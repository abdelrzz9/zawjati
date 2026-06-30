import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../../domain/entities/dashboard_metrics.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardMetrics metrics;

  const DashboardLoaded({required this.metrics});

  @override
  List<Object?> get props => [metrics];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;

  DashboardBloc({
    required this.getDashboardUseCase,
  }) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await getDashboardUseCase(NoParams());
    result.fold(
      (failure) => emit(DashboardError(failure.userFriendlyMessage)),
      (metrics) => emit(DashboardLoaded(metrics: metrics)),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_read_usecase.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {}

class MarkRead extends NotificationsEvent {
  final String notificationId;
  const MarkRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllRead extends NotificationsEvent {}

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;
  final int unreadCount;
  final int totalUnread;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
    required this.totalUnread,
  });

  NotificationsLoaded copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    int? totalUnread,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      totalUnread: totalUnread ?? this.totalUnread,
    );
  }

  @override
  List<Object?> get props => [notifications, unreadCount, totalUnread];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkReadUseCase markReadUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.markReadUseCase,
  }) : super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkRead>(_onMarkRead);
    on<MarkAllRead>(_onMarkAllRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    final result = await getNotificationsUseCase(NoParams());
    result.fold(
      (failure) => emit(NotificationsError(failure.userFriendlyMessage)),
      (notifications) {
        final unread = notifications.where((n) => !n.read).length;
        emit(NotificationsLoaded(
          notifications: notifications,
          unreadCount: unread,
          totalUnread: unread,
        ));
      },
    );
  }

  Future<void> _onMarkRead(
    MarkRead event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final current = state as NotificationsLoaded;
      emit(current.copyWith(
        notifications: current.notifications.map((n) {
          if (n.id == event.notificationId) {
            return AppNotification(
              id: n.id,
              type: n.type,
              title: n.title,
              body: n.body,
              data: n.data,
              read: true,
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList(),
        unreadCount: current.unreadCount > 0 ? current.unreadCount - 1 : 0,
        totalUnread: current.totalUnread > 0 ? current.totalUnread - 1 : 0,
      ));
    }
    final result = await markReadUseCase(MarkReadParams.single(event.notificationId));
    result.fold((failure) => null, (_) => null);
  }

  Future<void> _onMarkAllRead(
    MarkAllRead event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final current = state as NotificationsLoaded;
      emit(current.copyWith(
        notifications: current.notifications.map((n) => AppNotification(
          id: n.id,
          type: n.type,
          title: n.title,
          body: n.body,
          data: n.data,
          read: true,
          createdAt: n.createdAt,
        )).toList(),
        unreadCount: 0,
        totalUnread: 0,
      ));
    }
    final result = await markReadUseCase(const MarkReadParams.markAll());
    result.fold((failure) => null, (_) => null);
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/notifications/domain/entities/app_notification.dart';
import 'package:zawjati_mobile/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:zawjati_mobile/features/notifications/domain/usecases/mark_read_usecase.dart';
import 'package:zawjati_mobile/features/notifications/presentation/bloc/notifications_bloc.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}
class MockMarkReadUseCase extends Mock implements MarkReadUseCase {}

void main() {
  late MockGetNotificationsUseCase mockGet;
  late MockMarkReadUseCase mockMark;
  late NotificationsBloc bloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const MarkReadParams.markAll());
  });

  final testNotifications = <AppNotification>[
    AppNotification(
      id: 'notif-1',
      title: 'Test',
      body: 'Test message',
      type: 'info',
      read: false,
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  setUp(() {
    mockGet = MockGetNotificationsUseCase();
    mockMark = MockMarkReadUseCase();
    bloc = NotificationsBloc(
      getNotificationsUseCase: mockGet,
      markReadUseCase: mockMark,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('NotificationsBloc', () {
    blocTest<NotificationsBloc, NotificationsState>(
      'loads notifications',
      build: () {
        when(() => mockGet(any()))
            .thenAnswer((_) async => Right(testNotifications));
        return bloc;
      },
      act: (b) => b.add(LoadNotifications()),
      expect: () => [
        NotificationsLoading(),
        isA<NotificationsLoaded>(),
      ],
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'marks as read',
      build: () {
        when(() => mockMark(any()))
            .thenAnswer((_) async => const Right('notif-1'));
        return bloc;
      },
      seed: () => NotificationsLoaded(
        notifications: testNotifications,
        unreadCount: 1,
        totalUnread: 1,
      ),
      act: (b) => b.add(MarkRead('notif-1')),
      expect: () => [
        isA<NotificationsLoaded>().having(
          (s) => s.notifications.first.read,
          'read',
          true,
        ),
      ],
    );
  });
}

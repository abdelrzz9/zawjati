import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';

class MockInternetConnection extends Mock implements InternetConnection {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late MockInternetConnection mockConnectionChecker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockConnectionChecker = MockInternetConnection();
    networkInfo = NetworkInfoImpl(
      connectivity: mockConnectivity,
      connectionChecker: mockConnectionChecker,
    );
  });

  group('NetworkInfo', () {
    test('returns true when connected', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockConnectionChecker.hasInternetAccess)
          .thenAnswer((_) async => true);

      final result = await networkInfo.isConnected;
      expect(result, true);
    });

    test('returns false when disconnected', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final result = await networkInfo.isConnected;
      expect(result, false);
    });

    test('streams connection status', () {
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => const Stream.empty());

      expect(networkInfo.onConnectivityChanged, isA<Stream<bool>>());
    });
  });
}

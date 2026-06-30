import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:zawjati_mobile/features/voice/presentation/bloc/voice_bloc.dart';

void main() {
  late VoiceBloc voiceBloc;

  setUp(() {
    voiceBloc = VoiceBloc();
  });

  tearDown(() {
    voiceBloc.close();
  });

  group('VoiceBloc', () {
    test('initial state', () {
      expect(voiceBloc.state, const VoiceState());
    });

    blocTest<VoiceBloc, VoiceState>(
      'transitions to listening state',
      build: () => voiceBloc,
      act: (bloc) => bloc.add(const StartListening()),
      expect: () => [
        const VoiceState(isListening: true),
      ],
    );

    blocTest<VoiceBloc, VoiceState>(
      'stops listening',
      build: () => voiceBloc,
      act: (bloc) {
        bloc.add(const StartListening());
        bloc.add(const StopListening());
      },
      skip: 1,
      expect: () => [
        const VoiceState(),
      ],
    );
  });
}

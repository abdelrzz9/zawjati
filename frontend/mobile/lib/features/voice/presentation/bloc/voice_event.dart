part of 'voice_bloc.dart';

abstract class VoiceEvent extends Equatable {
  const VoiceEvent();

  @override
  List<Object?> get props => [];
}

class StartListening extends VoiceEvent {
  const StartListening();
}

class StopListening extends VoiceEvent {
  final String? transcript;

  const StopListening({this.transcript});

  @override
  List<Object?> get props => [transcript];
}

class StartSpeaking extends VoiceEvent {
  const StartSpeaking();
}

class StopSpeaking extends VoiceEvent {
  const StopSpeaking();
}

class ToggleHandsFree extends VoiceEvent {
  const ToggleHandsFree();
}

part of 'voice_bloc.dart';

class VoiceState extends Equatable {
  final bool isListening;
  final bool isSpeaking;
  final String? transcript;
  final bool isHandsFree;

  const VoiceState({
    this.isListening = false,
    this.isSpeaking = false,
    this.transcript,
    this.isHandsFree = false,
  });

  VoiceState copyWith({
    bool? isListening,
    bool? isSpeaking,
    String? transcript,
    bool? isHandsFree,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      transcript: transcript ?? this.transcript,
      isHandsFree: isHandsFree ?? this.isHandsFree,
    );
  }

  @override
  List<Object?> get props => [isListening, isSpeaking, transcript, isHandsFree];
}

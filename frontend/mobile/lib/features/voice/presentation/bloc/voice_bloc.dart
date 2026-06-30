import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  VoiceBloc() : super(const VoiceState()) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<StartSpeaking>(_onStartSpeaking);
    on<StopSpeaking>(_onStopSpeaking);
    on<ToggleHandsFree>(_onToggleHandsFree);
  }

  void _onStartListening(
    StartListening event,
    Emitter<VoiceState> emit,
  ) {
    emit(state.copyWith(isListening: true));
  }

  void _onStopListening(
    StopListening event,
    Emitter<VoiceState> emit,
  ) {
    emit(state.copyWith(isListening: false, transcript: event.transcript));
  }

  void _onStartSpeaking(
    StartSpeaking event,
    Emitter<VoiceState> emit,
  ) {
    emit(state.copyWith(isSpeaking: true));
  }

  void _onStopSpeaking(
    StopSpeaking event,
    Emitter<VoiceState> emit,
  ) {
    emit(state.copyWith(isSpeaking: false));
  }

  void _onToggleHandsFree(
    ToggleHandsFree event,
    Emitter<VoiceState> emit,
  ) {
    emit(state.copyWith(isHandsFree: !state.isHandsFree));
  }
}

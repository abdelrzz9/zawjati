part of 'personalities_bloc.dart';

abstract class PersonalitiesEvent extends Equatable {
  const PersonalitiesEvent();

  @override
  List<Object?> get props => [];
}

class GetPersonalitiesEvent extends PersonalitiesEvent {}

class SelectPersonalityEvent extends PersonalitiesEvent {
  final Personality? personality;

  const SelectPersonalityEvent({this.personality});

  @override
  List<Object?> get props => [personality];
}

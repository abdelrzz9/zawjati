part of 'personalities_bloc.dart';

abstract class PersonalitiesState extends Equatable {
  const PersonalitiesState();

  @override
  List<Object?> get props => [];
}

class PersonalitiesInitial extends PersonalitiesState {}

class PersonalitiesLoading extends PersonalitiesState {}

class PersonalitiesLoaded extends PersonalitiesState {
  final List<Personality> personalities;
  final Personality? selected;

  const PersonalitiesLoaded(this.personalities, this.selected);

  @override
  List<Object?> get props => [personalities, selected];
}

class PersonalitiesError extends PersonalitiesState {
  final String message;

  const PersonalitiesError(this.message);

  @override
  List<Object> get props => [message];
}

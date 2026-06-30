import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/personalities/domain/entities/personality.dart';
import 'package:zawjati_mobile/features/personalities/domain/usecases/get_personalities_usecase.dart';

part 'personalities_event.dart';
part 'personalities_state.dart';

class PersonalitiesBloc
    extends Bloc<PersonalitiesEvent, PersonalitiesState> {
  final GetPersonalitiesUseCase getPersonalitiesUseCase;

  PersonalitiesBloc({
    required this.getPersonalitiesUseCase,
  }) : super(PersonalitiesInitial()) {
    on<GetPersonalitiesEvent>(_onGetPersonalities);
    on<SelectPersonalityEvent>(_onSelectPersonality);
  }

  Future<void> _onGetPersonalities(
    GetPersonalitiesEvent event,
    Emitter<PersonalitiesState> emit,
  ) async {
    emit(PersonalitiesLoading());
    final result = await getPersonalitiesUseCase(NoParams());
    result.fold(
      (failure) => emit(PersonalitiesError(failure.userFriendlyMessage)),
      (personalities) =>
          emit(PersonalitiesLoaded(personalities, null)),
    );
  }

  void _onSelectPersonality(
    SelectPersonalityEvent event,
    Emitter<PersonalitiesState> emit,
  ) {
    final current = state;
    if (current is PersonalitiesLoaded) {
      emit(PersonalitiesLoaded(current.personalities, event.personality));
    }
  }
}

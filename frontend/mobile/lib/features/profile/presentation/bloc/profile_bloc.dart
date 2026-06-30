import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/features/profile/domain/entities/profile.dart';
import 'package:zawjati_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:zawjati_mobile/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getProfileUseCase(
      GetProfileParams(userId: event.userId),
    );
    result.fold(
      (failure) => emit(ProfileError(failure.userFriendlyMessage)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(
      UpdateProfileParams(userId: event.userId, profile: event.profile),
    );
    result.fold(
      (failure) => emit(ProfileError(failure.userFriendlyMessage)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}

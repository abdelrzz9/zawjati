part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  final String userId;

  const GetProfileEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  final String userId;
  final UserProfile profile;

  const UpdateProfileEvent({
    required this.userId,
    required this.profile,
  });

  @override
  List<Object?> get props => [userId, profile];
}

// profile_event.dart

import 'package:equatable/equatable.dart';
import '../../models/profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfiles extends ProfileEvent {}

class CreateProfile extends ProfileEvent { 
  final Profile profile;

  const CreateProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class UpdateProfile extends ProfileEvent {
  final int user_id;
  final Profile profile;

  const UpdateProfile(this.user_id, this.profile);

  @override
  List<Object> get props => [user_id, profile];
}

class DeleteProfile extends ProfileEvent {
  final int id;

  const DeleteProfile(this.id);

  @override
  List<Object> get props => [id];
}

class ShowProfile extends ProfileEvent {
  final int user_id;

  const ShowProfile(this.user_id);

  @override
  List<Object> get props => [user_id];
}

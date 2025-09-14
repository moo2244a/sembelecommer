part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoding extends ProfileState {}

final class ProfileSuss extends ProfileState {}

final class ProfileFile extends ProfileState {}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;
  ProfileImageUpdated(this.imageUrl);
}

final class ProfileFileImageUpdated extends ProfileState {}

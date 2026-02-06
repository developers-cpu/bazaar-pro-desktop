import 'package:equatable/equatable.dart';
import '../../../domain/entities/my_profile_entity.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object> get props => [];
}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoading extends MyProfileState {}

class MyProfileLoaded extends MyProfileState {
  final MyProfileEntity profile;

  const MyProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class MyProfileError extends MyProfileState {
  final String message;

  const MyProfileError(this.message);

  @override
  List<Object> get props => [message];
}

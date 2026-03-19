import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class NestedUsersState extends Equatable {
  const NestedUsersState();
  @override
  List<Object?> get props => [];
}

class NestedUsersInitial extends NestedUsersState {}

class NestedUsersLoading extends NestedUsersState {}

class NestedUsersLoaded extends NestedUsersState {
  final List<User> users;
  const NestedUsersLoaded({required this.users});
  @override
  List<Object?> get props => [users];
}

class NestedUsersError extends NestedUsersState {
  final String message;
  const NestedUsersError(this.message);
  @override
  List<Object?> get props => [message];
}
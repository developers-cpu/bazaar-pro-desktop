import 'package:equatable/equatable.dart';

abstract class NestedUsersEvent extends Equatable {
  const NestedUsersEvent();
  @override
  List<Object?> get props => [];
}

class LoadNestedUsers extends NestedUsersEvent {
  final String parentUserId;
  const LoadNestedUsers(this.parentUserId);
  @override
  List<Object?> get props => [parentUserId];
}
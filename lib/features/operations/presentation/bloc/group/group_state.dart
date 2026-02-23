import 'package:equatable/equatable.dart';

import '../../../domain/entities/group/group.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<Group> groups;

  const GroupsLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

class GroupOperationSuccess extends GroupState {
  final String message;

  const GroupOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupError extends GroupState {
  final String message;

  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}

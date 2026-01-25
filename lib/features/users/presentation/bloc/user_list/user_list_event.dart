import 'package:equatable/equatable.dart';

/// User List Events
abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UserListEvent {
  const LoadUsersEvent();
}

class FilterByUserTypeEvent extends UserListEvent {
  final String? userType;

  const FilterByUserTypeEvent(this.userType);

  @override
  List<Object?> get props => [userType];
}

class FilterByUserStatusEvent extends UserListEvent {
  final String? userStatus;

  const FilterByUserStatusEvent(this.userStatus);

  @override
  List<Object?> get props => [userStatus];
}

class ApplyFiltersEvent extends UserListEvent {
  final String? userType;
  final String? userStatus;

  const ApplyFiltersEvent({this.userType, this.userStatus});

  @override
  List<Object?> get props => [userType, userStatus];
}

class ResetFiltersEvent extends UserListEvent {
  const ResetFiltersEvent();
}

class SortByColumnEvent extends UserListEvent {
  final String columnId;
  final bool ascending;

  const SortByColumnEvent({required this.columnId, required this.ascending});

  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportToPdfEvent extends UserListEvent {
  const ExportToPdfEvent();
}

class ExportToExcelEvent extends UserListEvent {
  const ExportToExcelEvent();
}

class SelectUserEvent extends UserListEvent {
  final String? userId;

  const SelectUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

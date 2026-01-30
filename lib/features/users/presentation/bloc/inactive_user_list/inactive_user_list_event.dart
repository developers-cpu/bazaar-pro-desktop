import 'package:equatable/equatable.dart';

/// Inactive User List Events
abstract class InactiveUserListEvent extends Equatable {
  const InactiveUserListEvent();

  @override
  List<Object?> get props => [];
}

class LoadInactiveUsersEvent extends InactiveUserListEvent {
  const LoadInactiveUsersEvent();
}

class FilterInactiveByUserTypeEvent extends InactiveUserListEvent {
  final String? userType;

  const FilterInactiveByUserTypeEvent(this.userType);

  @override
  List<Object?> get props => [userType];
}

class FilterInactiveByUserStatusEvent extends InactiveUserListEvent {
  final String? userStatus;

  const FilterInactiveByUserStatusEvent(this.userStatus);

  @override
  List<Object?> get props => [userStatus];
}

class ApplyInactiveFiltersEvent extends InactiveUserListEvent {
  final String? userType;
  final String? userStatus;

  const ApplyInactiveFiltersEvent({this.userType, this.userStatus});

  @override
  List<Object?> get props => [userType, userStatus];
}

class ResetInactiveFiltersEvent extends InactiveUserListEvent {
  const ResetInactiveFiltersEvent();
}

class SortInactiveByColumnEvent extends InactiveUserListEvent {
  final String columnId;
  final bool ascending;

  const SortInactiveByColumnEvent({
    required this.columnId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportInactiveToPdfEvent extends InactiveUserListEvent {
  const ExportInactiveToPdfEvent();
}

class ExportInactiveToExcelEvent extends InactiveUserListEvent {
  const ExportInactiveToExcelEvent();
}

class SelectInactiveUserEvent extends InactiveUserListEvent {
  final String? userId;

  const SelectInactiveUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

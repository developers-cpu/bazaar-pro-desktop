import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class InactiveUserListState extends Equatable {
  const InactiveUserListState();

  @override
  List<Object?> get props => [];
}

class InactiveUserListInitial extends InactiveUserListState {
  const InactiveUserListInitial();
}

class InactiveUserListLoading extends InactiveUserListState {
  const InactiveUserListLoading();
}

class InactiveUserListLoaded extends InactiveUserListState {
  final List<User> allUsers;
  final List<User> filteredUsers;
  final List<String> userTypes;
  final List<String> userStatuses;
  final String? selectedUserType;
  final String? selectedUserStatus;
  final String? sortColumn;
  final bool sortAscending;
  final String? selectedUserId;
  final int totalRecords;

  const InactiveUserListLoaded({
    required this.allUsers,
    required this.filteredUsers,
    required this.userTypes,
    required this.userStatuses,
    this.selectedUserType,
    this.selectedUserStatus,
    this.sortColumn,
    this.sortAscending = true,
    this.selectedUserId,
    required this.totalRecords,
  });

  InactiveUserListLoaded copyWith({
    List<User>? allUsers,
    List<User>? filteredUsers,
    List<String>? userTypes,
    List<String>? userStatuses,
    String? selectedUserType,
    String? selectedUserStatus,
    String? sortColumn,
    bool? sortAscending,
    String? selectedUserId,
    int? totalRecords,
    bool clearUserType = false,
    bool clearUserStatus = false,
  }) {
    return InactiveUserListLoaded(
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      userTypes: userTypes ?? this.userTypes,
      userStatuses: userStatuses ?? this.userStatuses,
      selectedUserType: clearUserType
          ? null
          : (selectedUserType ?? this.selectedUserType),
      selectedUserStatus: clearUserStatus
          ? null
          : (selectedUserStatus ?? this.selectedUserStatus),
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }

  @override
  List<Object?> get props => [
    allUsers,
    filteredUsers,
    userTypes,
    userStatuses,
    selectedUserType,
    selectedUserStatus,
    sortColumn,
    sortAscending,
    selectedUserId,
    totalRecords,
  ];
}

class InactiveUserListError extends InactiveUserListState {
  final String message;

  const InactiveUserListError(this.message);

  @override
  List<Object?> get props => [message];
}

class InactiveUserListExporting extends InactiveUserListState {
  final String exportType; 

  const InactiveUserListExporting(this.exportType);

  @override
  List<Object?> get props => [exportType];
}

class InactiveUserListExportSuccess extends InactiveUserListState {
  final String message;
  final String filePath;

  const InactiveUserListExportSuccess({
    required this.message,
    required this.filePath,
  });

  @override
  List<Object?> get props => [message, filePath];
}

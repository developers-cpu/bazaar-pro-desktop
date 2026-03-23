import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class UserListState extends Equatable {
  const UserListState();
  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {
  const UserListInitial();
}

class UserListLoading extends UserListState {
  const UserListLoading();
}

class UserListLoaded extends UserListState {
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
  const UserListLoaded({
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
  UserListLoaded copyWith({
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
    return UserListLoaded(
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

class UserListError extends UserListState {
  final String message;
  const UserListError(this.message);
  @override
  List<Object?> get props => [message];
}

class UserListExporting extends UserListState {
  final String exportType;
  const UserListExporting(this.exportType);
  @override
  List<Object?> get props => [exportType];
}

class UserListExportSuccess extends UserListState {
  final String message;
  final String filePath;
  const UserListExportSuccess({required this.message, required this.filePath});
  @override
  List<Object?> get props => [message, filePath];
}

import 'package:equatable/equatable.dart';
import '../../../domain/entities/users_bill_summary/users_bill_summary_entity.dart';

abstract class UsersBillSummaryState extends Equatable {
  const UsersBillSummaryState();
  @override
  List<Object?> get props => [];
}

class UsersBillSummaryInitial extends UsersBillSummaryState {}

class UsersBillSummaryLoading extends UsersBillSummaryState {
  final List<String> users;
  const UsersBillSummaryLoading({this.users = const []});
  @override
  List<Object?> get props => [users];
}

class UsersBillSummaryUsersLoaded extends UsersBillSummaryState {
  final List<String> users;
  const UsersBillSummaryUsersLoaded(this.users);
  @override
  List<Object?> get props => [users];
}

class UsersBillSummaryDataLoaded extends UsersBillSummaryState {
  final List<String> users;
  final List<UsersBillSummaryEntity> summaryData;
  final String? selectedUser;
  const UsersBillSummaryDataLoaded({
    required this.users,
    required this.summaryData,
    this.selectedUser,
  });
  @override
  List<Object?> get props => [users, summaryData, selectedUser];
}

class UsersBillSummaryError extends UsersBillSummaryState {
  final String message;
  const UsersBillSummaryError(this.message);
  @override
  List<Object?> get props => [message];
}
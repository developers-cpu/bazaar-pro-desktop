import 'package:equatable/equatable.dart';

abstract class UsersBillSummaryEvent extends Equatable {
  const UsersBillSummaryEvent();
  @override
  List<Object?> get props => [];
}

class GetUsersListEvent extends UsersBillSummaryEvent {}

class GetUserBillSummaryEvent extends UsersBillSummaryEvent {
  final String userId;
  const GetUserBillSummaryEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_wise_profit_and_loss_report.dart';
abstract class UserWiseProfitAndLossState extends Equatable {
  const UserWiseProfitAndLossState();
  @override
  List<Object?> get props => [];
}
class UserWiseProfitAndLossInitial extends UserWiseProfitAndLossState {}
class UserWiseProfitAndLossLoading extends UserWiseProfitAndLossState {}
class UserWiseProfitAndLossLoaded extends UserWiseProfitAndLossState {
  final List<UserWiseProfitAndLossReport> reports;
  final List<String> userNames;
  final String? startDate;
  final String? endDate;
  final String? selectedUser;
  const UserWiseProfitAndLossLoaded({
    required this.reports,
    required this.userNames,
    this.startDate,
    this.endDate,
    this.selectedUser,
  });
  @override
  List<Object?> get props => [
    reports,
    userNames,
    startDate,
    endDate,
    selectedUser,
  ];
}
class UserWiseProfitAndLossError extends UserWiseProfitAndLossState {
  final String message;
  const UserWiseProfitAndLossError({required this.message});
  @override
  List<Object?> get props => [message];
}

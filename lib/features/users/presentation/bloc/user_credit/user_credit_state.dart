import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_credit_transaction.dart';


abstract class UserCreditState extends Equatable {
  const UserCreditState();

  @override
  List<Object?> get props => [];
}

class UserCreditLoading extends UserCreditState {}

class UserCreditLoaded extends UserCreditState {
  final List<UserCreditTransaction> transactions;
  final double totalBalance;

  const UserCreditLoaded({
    required this.transactions,
    required this.totalBalance,
  });

  @override
  List<Object?> get props => [transactions, totalBalance];
}

class UserCreditError extends UserCreditState {
  final String message;
  const UserCreditError(this.message);

  @override
  List<Object?> get props => [message];
}

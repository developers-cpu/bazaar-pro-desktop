import 'package:equatable/equatable.dart';
abstract class UserCreditEvent extends Equatable {
  const UserCreditEvent();
  @override
  List<Object?> get props => [];
}
class LoadUserCredit extends UserCreditEvent {
  final String userId;
  const LoadUserCredit(this.userId);
  @override
  List<Object?> get props => [userId];
}
class AddCreditTransaction extends UserCreditEvent {
  final String type;
  final double amount;
  final String comment;
  const AddCreditTransaction({
    required this.type,
    required this.amount,
    required this.comment,
  });
  @override
  List<Object?> get props => [type, amount, comment];
}

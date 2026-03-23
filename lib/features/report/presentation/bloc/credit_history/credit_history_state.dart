import 'package:bazarpro/features/report/domain/entities/credit_history.dart';
import 'package:equatable/equatable.dart';

abstract class CreditHistoryState extends Equatable {
  const CreditHistoryState();
  @override
  List<Object?> get props => [];
}

class CreditHistoryInitial extends CreditHistoryState {}

class CreditHistoryLoading extends CreditHistoryState {}

class CreditHistoryLoaded extends CreditHistoryState {
  final List<CreditHistory> creditHistory;
  final List<String> users;
  final String? selectedType;
  final String? selectedUser;
  const CreditHistoryLoaded({
    required this.creditHistory,
    this.users = const [],
    this.selectedType,
    this.selectedUser,
  });
  CreditHistoryLoaded copyWith({
    List<CreditHistory>? creditHistory,
    List<String>? users,
    String? selectedType,
    String? selectedUser,
  }) {
    return CreditHistoryLoaded(
      creditHistory: creditHistory ?? this.creditHistory,
      users: users ?? this.users,
      selectedType: selectedType ?? this.selectedType,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }

  @override
  List<Object?> get props => [creditHistory, users, selectedType, selectedUser];
}

class CreditHistoryError extends CreditHistoryState {
  final String message;
  const CreditHistoryError({required this.message});
  @override
  List<Object> get props => [message];
}

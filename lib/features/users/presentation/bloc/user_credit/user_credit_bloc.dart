import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/user_credit_transaction.dart';
import 'user_credit_event.dart';
import 'user_credit_state.dart';


class UserCreditBloc extends Bloc<UserCreditEvent, UserCreditState> {
  UserCreditBloc() : super(UserCreditLoading()) {
    on<LoadUserCredit>(_onLoadUserCredit);
    on<AddCreditTransaction>(_onAddCreditTransaction);
  }

  // Mock initial data
  final List<UserCreditTransaction> _mockTransactions = [
    UserCreditTransaction(
      id: '1',
      dateTime: DateTime.now(), // Display formatted later
      type: 'Credit',
      amount: 500000.00,
      balance: 6000000.00,
      comment: 'Initial Credit',
    ),
    UserCreditTransaction(
      id: '2',
      dateTime: DateTime.now(),
      type: 'Credit',
      amount: 500000.00,
      balance: 5500000.00,
      comment: 'Initial Credit',
    ),
    UserCreditTransaction(
      id: '3',
      dateTime: DateTime.now(),
      type: 'Debit',
      amount: -500000.00,
      balance: 5000000.00,
      comment: 'Initial Debit',
    ),
    UserCreditTransaction(
      id: '4',
      dateTime: DateTime.now(),
      type: 'Credit',
      amount: 5500000.00,
      balance: 5500000.00,
      comment:
          'Initial Debit', // Typo in original but keeping for consistency or fixing
    ),
    UserCreditTransaction(
      id: '5',
      dateTime: DateTime.now(),
      type: 'Debit',
      amount: -500000.00,
      balance: 0.00,
      comment: 'Initial Debit',
    ),
    UserCreditTransaction(
      id: '6',
      dateTime: DateTime.now(),
      type: 'Credit',
      amount: 500000.00,
      balance: 500000.00,
      comment: 'Initial Credit',
    ),
    UserCreditTransaction(
      id: '7',
      dateTime: DateTime.now(),
      type: 'Debit',
      amount: -500000.00,
      balance: 0.00,
      comment: 'Initial Debit',
    ),
    UserCreditTransaction(
      id: '8',
      dateTime: DateTime.now(),
      type: 'Credit',
      amount: 500000.00,
      balance: 500000.00,
      comment: 'Initial Credit',
    ),
    UserCreditTransaction(
      id: '9',
      dateTime: DateTime.now(),
      type: 'Debit',
      amount: -500000.00,
      balance: 0.00,
      comment: 'Initial Debit',
    ),
    UserCreditTransaction(
      id: '10',
      dateTime: DateTime.now(),
      type: 'Credit',
      amount: 500000.00,
      balance: 500000.00,
      comment: 'Initial Credit',
    ),
  ];

  void _onLoadUserCredit(
    LoadUserCredit event,
    Emitter<UserCreditState> emit,
  ) async {
    emit(UserCreditLoading());
    await Future.delayed(const Duration(seconds: 1));
    // Calculate initial total balance from mock data or existing logic
    // For now hardcode or sum
    double total = 6000000.00; // From screenshot footer
    emit(
      UserCreditLoaded(transactions: _mockTransactions, totalBalance: total),
    );
  }

  void _onAddCreditTransaction(
    AddCreditTransaction event,
    Emitter<UserCreditState> emit,
  ) {
    if (state is UserCreditLoaded) {
      final currentState = state as UserCreditLoaded;
      final newTx = UserCreditTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dateTime: DateTime.now(),
        type: event.type,
        amount: event.type == 'Debit' ? -event.amount : event.amount,
        balance:
            currentState.totalBalance +
            (event.type == 'Debit'
                ? -event.amount
                : event.amount), // Simple logic
        comment: event.comment,
      );

      final updatedList = [newTx, ...currentState.transactions];
      final newTotal = newTx.balance; // Assuming balance tracks accumulation

      emit(UserCreditLoaded(transactions: updatedList, totalBalance: newTotal));
    }
  }
}

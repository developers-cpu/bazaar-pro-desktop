import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user_credit_transaction/get_user_credit_usecase.dart';
import 'user_credit_event.dart';
import 'user_credit_state.dart';
class UserCreditBloc extends Bloc<UserCreditEvent, UserCreditState> {
  final GetUserCredit getUserCredit;
  UserCreditBloc({required this.getUserCredit}) : super(UserCreditLoading()) {
    on<LoadUserCredit>(_onLoadUserCredit);
    on<AddCreditTransaction>(_onAddCreditTransaction);
  }
  void _onLoadUserCredit(
    LoadUserCredit event,
    Emitter<UserCreditState> emit,
  ) async {
    emit(UserCreditLoading());
    final result = await getUserCredit(event.userId);
    result.fold((failure) => emit(UserCreditError(failure.message)), (
      transactions,
    ) {
      double total = 0;
      if (transactions.isNotEmpty) {
        total = transactions.first.balance;
      }
      emit(UserCreditLoaded(transactions: transactions, totalBalance: total));
    });
  }
  void _onAddCreditTransaction(
    AddCreditTransaction event,
    Emitter<UserCreditState> emit,
  ) {}
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_credit_history.dart';
import 'credit_history_event.dart';
import 'credit_history_state.dart';
class CreditHistoryBloc extends Bloc<CreditHistoryEvent, CreditHistoryState> {
  final GetCreditHistoryUseCase getCreditHistory;
  CreditHistoryBloc({required this.getCreditHistory})
    : super(CreditHistoryInitial()) {
    on<LoadCreditHistory>(_onLoadCreditHistory);
    on<FilterCreditHistory>(_onFilterCreditHistory);
    on<CreditHistoryFilter>(_onCreditHistoryFilter);
    on<ResetCreditHistoryFilters>(_onResetCreditHistoryFilters);
  }
  void _onCreditHistoryFilter(
    CreditHistoryFilter event,
    Emitter<CreditHistoryState> emit,
  ) {
    final currentState = state;
    if (currentState is CreditHistoryLoaded) {
      emit(
        currentState.copyWith(
          selectedType: event.type ?? currentState.selectedType,
          selectedUser: event.user ?? currentState.selectedUser,
        ),
      );
    }
  }
  Future<void> _onLoadCreditHistory(
    LoadCreditHistory event,
    Emitter<CreditHistoryState> emit,
  ) async {
    emit(CreditHistoryLoading());
    final result = await getCreditHistory();
    result.fold(
      (failure) =>
          emit(const CreditHistoryError(message: 'Failed to load data')),
      (data) {
        final users = data.map((e) => e.userName).toSet().toList()..sort();
        emit(CreditHistoryLoaded(creditHistory: data, users: users));
      },
    );
  }
  Future<void> _onFilterCreditHistory(
    FilterCreditHistory event,
    Emitter<CreditHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreditHistoryLoaded) {
      final type = event.type ?? currentState.selectedType;
      final user = event.user ?? currentState.selectedUser;
      final result = await getCreditHistory(type: type, search: user);
      result.fold(
        (failure) =>
            emit(const CreditHistoryError(message: 'Failed to filter data')),
        (data) => emit(
          currentState.copyWith(
            creditHistory: data,
            selectedType: type,
            selectedUser: user,
          ),
        ),
      );
    }
  }
  Future<void> _onResetCreditHistoryFilters(
    ResetCreditHistoryFilters event,
    Emitter<CreditHistoryState> emit,
  ) async {
    emit(CreditHistoryLoading());
    final result = await getCreditHistory();
    result.fold(
      (failure) =>
          emit(const CreditHistoryError(message: 'Failed to reset data')),
      (data) {
        final users = data.map((e) => e.userName).toSet().toList()..sort();
        emit(
          CreditHistoryLoaded(
            creditHistory: data,
            users: users,
            selectedType: null,
            selectedUser: null,
          ),
        );
      },
    );
  }
}

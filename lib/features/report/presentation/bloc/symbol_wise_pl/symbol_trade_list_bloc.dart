import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/symbol_wise_pl_repository.dart';
import 'symbol_trade_list_event.dart';
import 'symbol_trade_list_state.dart';

class SymbolTradeListBloc
    extends Bloc<SymbolTradeListEvent, SymbolTradeListState> {
  final SymbolWisePLRepository repository;

  SymbolTradeListBloc({required this.repository})
    : super(SymbolTradeListInitial()) {
    on<LoadSymbolTradeList>(_onLoadSymbolTradeList);
  }

  Future<void> _onLoadSymbolTradeList(
    LoadSymbolTradeList event,
    Emitter<SymbolTradeListState> emit,
  ) async {
    emit(SymbolTradeListLoading());
    final result = await repository.getSymbolTradeLog(symbol: event.symbol);
    result.fold(
      (failure) => emit(SymbolTradeListError(failure.message)),
      (tradeLogs) => emit(SymbolTradeListLoaded(tradeLogs)),
    );
  }
}

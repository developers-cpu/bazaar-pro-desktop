import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/symbol_wise_pl/symbol_wise_pl_repository.dart';
import 'symbol_open_position_event.dart';
import 'symbol_open_position_state.dart';
class SymbolOpenPositionBloc
    extends Bloc<SymbolOpenPositionEvent, SymbolOpenPositionState> {
  final SymbolWisePLRepository repository;
  SymbolOpenPositionBloc({required this.repository})
    : super(SymbolOpenPositionInitial()) {
    on<LoadSymbolOpenPosition>(_onLoadSymbolOpenPosition);
  }
  Future<void> _onLoadSymbolOpenPosition(
    LoadSymbolOpenPosition event,
    Emitter<SymbolOpenPositionState> emit,
  ) async {
    emit(SymbolOpenPositionLoading());
    final result = await repository.getSymbolOpenPosition(
      symbol: event.symbol,
      exchange: event.exchange,
      user: event.user,
    );
    result.fold(
      (failure) => emit(SymbolOpenPositionError(failure.message)),
      (positions) => emit(SymbolOpenPositionLoaded(positions)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/user_position/get_user_positions.dart';
import '../../../domain/usecases/user/get_exchanges.dart';
import '../../../domain/usecases/user/get_symbols.dart';
import '../../../domain/entities/user_position/user_position.dart';
part 'user_position_event.dart';
part 'user_position_state.dart';

class UserPositionBloc extends Bloc<UserPositionEvent, UserPositionState> {
  final GetUserPositions getUserPositions;
  final GetExchanges getExchanges;
  final GetSymbols getSymbols;
  UserPositionBloc({
    required this.getUserPositions,
    required this.getExchanges,
    required this.getSymbols,
  }) : super(UserPositionInitial()) {
    on<LoadUserPositions>(_onLoadUserPositions);
    on<FilterUserPositions>(_onFilterUserPositions);
  }
  Future<void> _onLoadUserPositions(
    LoadUserPositions event,
    Emitter<UserPositionState> emit,
  ) async {
    emit(UserPositionLoading());
    final positionsResult = await getUserPositions(event.userId);
    final exchangesResult = await getExchanges();
    final symbolsResult = await getSymbols();
    List<String> exchanges = [];
    exchangesResult.fold((l) => null, (r) => exchanges = r);
    List<String> symbols = [];
    symbolsResult.fold((l) => null, (r) => symbols = r);
    positionsResult.fold(
      (failure) => emit(UserPositionError(failure.message)),
      (positions) => emit(
        UserPositionLoaded(
          allPositions: positions,
          filteredPositions: positions,
          exchanges: exchanges,
          symbols: symbols,
        ),
      ),
    );
  }

  void _onFilterUserPositions(
    FilterUserPositions event,
    Emitter<UserPositionState> emit,
  ) {
    if (state is UserPositionLoaded) {
      final currentState = state as UserPositionLoaded;
      final allPositions = currentState.allPositions;
      List<UserPosition> filtered = List.from(allPositions);
      if (event.exchange != null) {
        filtered = filtered
            .where(
              (p) => p.exchange.toLowerCase().contains(
                event.exchange!.toLowerCase(),
              ),
            )
            .toList();
      }
      if (event.symbol != null) {
        filtered = filtered
            .where(
              (p) =>
                  p.symbol.toLowerCase().contains(event.symbol!.toLowerCase()),
            )
            .toList();
      }
      emit(
        currentState.copyWith(
          filteredPositions: filtered,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
        ),
      );
    }
  }
}

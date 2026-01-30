import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_position.dart';

part 'user_position_event.dart';
part 'user_position_state.dart';

class UserPositionBloc extends Bloc<UserPositionEvent, UserPositionState> {
  UserPositionBloc() : super(UserPositionInitial()) {
    on<LoadUserPositions>(_onLoadUserPositions);
    on<FilterUserPositions>(_onFilterUserPositions);
  }

  // Mock data as provided
  final List<Map<String, dynamic>> _mockPositions = [
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': 124191.0,
      'cmp': -124191.0,
      'm2m': -124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 1000000.0,
      'sellQty': 1000000.0,
      'netQty': 1000000.0,
      'netAp': 124191.0,
      'cmp': 124191.0,
      'm2m': 124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': -256.0,
      'cmp': -256.0,
      'm2m': -256.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 100.0,
      'sellQty': 100.0,
      'netQty': 100.0,
      'netAp': 124191.0,
      'cmp': 124191.0,
      'm2m': 124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': 124191.0,
      'cmp': -124191.0,
      'm2m': -124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 100.0,
      'sellQty': 100.0,
      'netQty': 100.0,
      'netAp': 124191.0,
      'cmp': 124191.0,
      'm2m': 124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': 124191.0,
      'cmp': -124191.0,
      'm2m': -124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 1000000.0,
      'sellQty': 1000000.0,
      'netQty': 1000000.0,
      'netAp': 124191.0,
      'cmp': 124191.0,
      'm2m': 124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': -256.0,
      'cmp': -256.0,
      'm2m': -256.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 100.0,
      'sellQty': 100.0,
      'netQty': 100.0,
      'netAp': 124191.0,
      'cmp': 124191.0,
      'm2m': 124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 500.0,
      'sellQty': 500.0,
      'netQty': 500.0,
      'netAp': 124191.0,
      'cmp': -124191.0,
      'm2m': -124191.0,
      'lot': 1.0,
    },
    {
      'exch': 'MCX',
      'symbol': 'GOLD05DEC',
      'buyQty': 100.0,
      'sellQty': 100.0,
      'netQty': 100.0,
      'netAp': 124191.0,
      'cmp': 124191.0,
      'm2m': 124191.0,
      'lot': 1.0,
    },
  ];

  Future<void> _onLoadUserPositions(
    LoadUserPositions event,
    Emitter<UserPositionState> emit,
  ) async {
    emit(UserPositionLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final positions = _mockPositions
          .map((e) => UserPosition.fromMap(e))
          .toList();
      emit(
        UserPositionLoaded(
          allPositions: positions,
          filteredPositions: positions,
        ),
      );
    } catch (e) {
      emit(UserPositionError(e.toString()));
    }
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

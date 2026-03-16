import 'package:bazarpro/features/users/domain/entities/user_trade_margin/user_trade_margin.dart';
import 'package:bazarpro/features/users/domain/usecases/user_trade_margin/get_user_trade_margin_usecase.dart';
import 'package:bazarpro/features/users/domain/usecases/user_trade_margin/get_user_trade_margin_metadata_usecase.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_trade_margin_event.dart';
import 'user_trade_margin_state.dart';
class UserTradeMarginBloc
    extends Bloc<UserTradeMarginEvent, UserTradeMarginState> {
  final GetUserTradeMargin getUserTradeMargin;
  final GetUserTradeMarginMetadata getUserTradeMarginMetadata;
  UserTradeMarginBloc({
    required this.getUserTradeMargin,
    required this.getUserTradeMarginMetadata,
  }) : super(UserTradeMarginInitial()) {
    on<LoadUserTradeMargin>(_onLoadMargins);
    on<FilterUserTradeMargins>(_onFilterMargins);
    on<ToggleAllUserTradeMarginSelection>(_onToggleSelectAll);
    on<ToggleUserTradeMarginSelection>(_onToggleSelectRow);
    on<UpdateUserTradeMargins>(_onUpdateMargins);
  }
  void _onLoadMargins(
    LoadUserTradeMargin event,
    Emitter<UserTradeMarginState> emit,
  ) async {
    emit(UserTradeMarginLoading());
    final marginsResult = await getUserTradeMargin(event.userId);
    final metadataResult = await getUserTradeMarginMetadata(NoParams());
    marginsResult.fold(
      (failure) => emit(UserTradeMarginError(failure.message)),
      (margins) {
        metadataResult.fold(
          (metaFailure) => emit(
            UserTradeMarginLoaded(
              margins: margins,
              filteredMargins: margins,
              metadata: null,
            ),
          ),
          (metadata) => emit(
            UserTradeMarginLoaded(
              margins: margins,
              filteredMargins: margins,
              metadata: metadata,
            ),
          ),
        );
      },
    );
  }
  void _onFilterMargins(
    FilterUserTradeMargins event,
    Emitter<UserTradeMarginState> emit,
  ) {
    if (state is UserTradeMarginLoaded) {
      final currentState = state as UserTradeMarginLoaded;
      List<UserTradeMargin> filtered = currentState.margins;
      if (event.exchange != null && event.exchange != 'All') {
        filtered = filtered.where((m) => m.exchange == event.exchange).toList();
      }
      if (event.symbol != null && event.symbol!.isNotEmpty) {
        filtered = filtered
            .where(
              (m) =>
                  m.symbol.toLowerCase().contains(event.symbol!.toLowerCase()),
            )
            .toList();
      }
      emit(
        currentState.copyWith(
          filteredMargins: filtered,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
        ),
      );
    }
  }
  void _onToggleSelectAll(
    ToggleAllUserTradeMarginSelection event,
    Emitter<UserTradeMarginState> emit,
  ) {
    if (state is UserTradeMarginLoaded) {
      final currentState = state as UserTradeMarginLoaded;
      final updatedMargins = currentState.filteredMargins.map((m) {
        return m.copyWith(isSelected: event.isSelected);
      }).toList();
      emit(
        currentState.copyWith(
          filteredMargins: updatedMargins,
          isAllSelected: event.isSelected,
        ),
      );
    }
  }
  void _onToggleSelectRow(
    ToggleUserTradeMarginSelection event,
    Emitter<UserTradeMarginState> emit,
  ) {
    if (state is UserTradeMarginLoaded) {
      final currentState = state as UserTradeMarginLoaded;
      final updatedMargins = currentState.filteredMargins.map((m) {
        if (m.id == event.id) {
          return m.copyWith(isSelected: event.isSelected);
        }
        return m;
      }).toList();
      bool allSelected = updatedMargins.every((m) => m.isSelected);
      emit(
        currentState.copyWith(
          filteredMargins: updatedMargins,
          isAllSelected: allSelected,
        ),
      );
    }
  }
  void _onUpdateMargins(
    UpdateUserTradeMargins event,
    Emitter<UserTradeMarginState> emit,
  ) {
    print('Updating margins: IDs=${event.selectedIds}');
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_pending_order_event.dart';
import 'user_pending_order_state.dart';

class UserPendingOrderBloc
    extends Bloc<UserPendingOrderEvent, UserPendingOrderState> {
  UserPendingOrderBloc() : super(UserPendingOrderLoading()) {
    on<LoadUserPendingOrders>(_onLoadUserPendingOrders);
    on<FilterUserPendingOrders>(_onFilterUserPendingOrders);
  }

  void _onLoadUserPendingOrders(
    LoadUserPendingOrders event,
    Emitter<UserPendingOrderState> emit,
  ) async {
    emit(UserPendingOrderLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    emit(const UserPendingOrderLoaded(orders: [])); // Initial empty state
  }

  void _onFilterUserPendingOrders(
    FilterUserPendingOrders event,
    Emitter<UserPendingOrderState> emit,
  ) {
    if (state is UserPendingOrderLoaded) {
      final currentState = state as UserPendingOrderLoaded;
      emit(
        currentState.copyWith(
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
          selectedOrderType: event.orderType,
        ),
      );
    }
  }
}

import 'package:bazarpro/features/users/domain/entities/user_pending_order/user_pending_order.dart';
import 'package:bazarpro/features/users/domain/usecases/user_pending_order/get_user_pending_orders_usecase.dart';
import 'package:bazarpro/features/users/domain/usecases/user_pending_order/get_user_pending_order_metadata_usecase.dart';
import '../../../../../../core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_pending_order_event.dart';
import 'user_pending_order_state.dart';

class UserPendingOrderBloc
    extends Bloc<UserPendingOrderEvent, UserPendingOrderState> {
  final GetUserPendingOrders getUserPendingOrders;
  final GetUserPendingOrderMetadata getUserPendingOrderMetadata;

  UserPendingOrderBloc({
    required this.getUserPendingOrders,
    required this.getUserPendingOrderMetadata,
  }) : super(UserPendingOrderInitial()) {
    on<LoadUserPendingOrders>(_onLoadOrders);
    on<FilterUserPendingOrders>(_onFilterOrders);
  }

  void _onLoadOrders(
    LoadUserPendingOrders event,
    Emitter<UserPendingOrderState> emit,
  ) async {
    emit(UserPendingOrderLoading());

    final orderResult = await getUserPendingOrders(event.userId);
    final metadataResult = await getUserPendingOrderMetadata(NoParams());

    orderResult.fold(
      (failure) => emit(UserPendingOrderError(failure.message)),
      (orders) {
        metadataResult.fold(
          (metadataFailure) => emit(
            UserPendingOrderLoaded(
              orders: orders,
              filteredOrders: orders,
              metadata: null,
            ),
          ),
          (metadata) => emit(
            UserPendingOrderLoaded(
              orders: orders,
              filteredOrders: orders,
              metadata: metadata,
            ),
          ),
        );
      },
    );
  }

  void _onFilterOrders(
    FilterUserPendingOrders event,
    Emitter<UserPendingOrderState> emit,
  ) {
    if (state is UserPendingOrderLoaded) {
      final currentState = state as UserPendingOrderLoaded;
      List<UserPendingOrder> filtered = currentState.orders;

      if (event.exchange != null &&
          event.exchange != 'All' &&
          event.exchange!.isNotEmpty) {
        filtered = filtered.where((o) => o.exchange == event.exchange).toList();
      }
      if (event.symbol != null &&
          event.symbol != 'All' &&
          event.symbol!.isNotEmpty) {
        filtered = filtered.where((o) => o.symbol == event.symbol).toList();
      }
      if (event.orderType != null &&
          event.orderType != 'All' &&
          event.orderType!.isNotEmpty) {
        filtered = filtered.where((o) => o.type == event.orderType).toList();
      }

      emit(
        currentState.copyWith(
          filteredOrders: filtered,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
          selectedOrderType: event.orderType,
        ),
      );
    }
  }
}

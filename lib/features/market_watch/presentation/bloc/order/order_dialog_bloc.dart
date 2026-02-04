import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/order_dialog_type.dart';
import 'order_dialog_event.dart';
import 'order_dialog_state.dart';
class OrderDialogBloc extends Bloc<OrderDialogEvent, OrderDialogState> {
  OrderDialogBloc() : super(const OrderDialogState()) {
    on<OpenBuyOrderEvent>(_onOpenBuyOrder);
    on<OpenSellOrderEvent>(_onOpenSellOrder);
    on<CloseOrderDialogEvent>(_onCloseDialog);
    on<UpdateClientNameEvent>(_onUpdateClientName);
    on<UpdateOrderTypeEvent>(_onUpdateOrderType);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<UpdateLotEvent>(_onUpdateLot);
    on<UpdatePriceEvent>(_onUpdatePrice);
    on<UpdateExchangeEvent>(_onUpdateExchange);
    on<UpdateSymbolEvent>(_onUpdateSymbol);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<IncrementLotEvent>(_onIncrementLot);
    on<DecrementLotEvent>(_onDecrementLot);
    on<IncrementPriceEvent>(_onIncrementPrice);
    on<DecrementPriceEvent>(_onDecrementPrice);
    on<SubmitOrderEvent>(_onSubmitOrder);
    on<ResetSubmittedEvent>(_onResetSubmitted);
  }
  void _onOpenBuyOrder(
      OpenBuyOrderEvent event, Emitter<OrderDialogState> emit) {
    emit(OrderDialogState(
      dialogType: OrderDialogTypeEnum.buy,
      exchange: event.exchange ?? '',
      symbol: event.symbol ?? '',
      quantity: 1,
      lot: 1,
      price: 0.0,
    ));
  }
  void _onOpenSellOrder(
      OpenSellOrderEvent event, Emitter<OrderDialogState> emit) {
    emit(OrderDialogState(
      dialogType: OrderDialogTypeEnum.sell,
      exchange: event.exchange ?? '',
      symbol: event.symbol ?? '',
      quantity: 1,
      lot: 1,
      price: 0.0,
    ));
  }
  void _onCloseDialog(
      CloseOrderDialogEvent event, Emitter<OrderDialogState> emit) {
    emit(const OrderDialogState());
  }
  void _onUpdateClientName(
      UpdateClientNameEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(clientName: event.clientName));
  }
  void _onUpdateOrderType(
      UpdateOrderTypeEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(orderType: event.orderType));
  }
  void _onUpdateQuantity(
      UpdateQuantityEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(quantity: event.quantity));
  }
  void _onUpdateLot(UpdateLotEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(lot: event.lot));
  }
  void _onUpdatePrice(UpdatePriceEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(price: event.price));
  }
  void _onUpdateExchange(
      UpdateExchangeEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(exchange: event.exchange));
  }
  void _onUpdateSymbol(
      UpdateSymbolEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(symbol: event.symbol));
  }
  void _onIncrementQuantity(
      IncrementQuantityEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(quantity: state.quantity + 1));
  }
  void _onDecrementQuantity(
      DecrementQuantityEvent event, Emitter<OrderDialogState> emit) {
    if (state.quantity > 0) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }
  void _onIncrementLot(
      IncrementLotEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(lot: state.lot + 1));
  }
  void _onDecrementLot(
      DecrementLotEvent event, Emitter<OrderDialogState> emit) {
    if (state.lot > 0) {
      emit(state.copyWith(lot: state.lot - 1));
    }
  }
  void _onIncrementPrice(
      IncrementPriceEvent event, Emitter<OrderDialogState> emit) {
    emit(state.copyWith(price: state.price + 0.05));
  }
  void _onDecrementPrice(
      DecrementPriceEvent event, Emitter<OrderDialogState> emit) {
    if (state.price > 0) {
      emit(state.copyWith(price: state.price - 0.05));
    }
  }
  void _onSubmitOrder(
      SubmitOrderEvent event, Emitter<OrderDialogState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(isLoading: false, isSubmitted: true));
  }
  void _onResetSubmitted(
      ResetSubmittedEvent event, Emitter<OrderDialogState> emit) {
    emit(const OrderDialogState());
  }
}

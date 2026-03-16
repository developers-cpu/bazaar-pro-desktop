import 'package:equatable/equatable.dart';
abstract class OrderDialogEvent extends Equatable {
  const OrderDialogEvent();
  @override
  List<Object?> get props => [];
}
class OpenBuyOrderEvent extends OrderDialogEvent {
  final String? exchange;
  final String? symbol;
  const OpenBuyOrderEvent({this.exchange, this.symbol});
  @override
  List<Object?> get props => [exchange, symbol];
}
class OpenSellOrderEvent extends OrderDialogEvent {
  final String? exchange;
  final String? symbol;
  const OpenSellOrderEvent({this.exchange, this.symbol});
  @override
  List<Object?> get props => [exchange, symbol];
}
class CloseOrderDialogEvent extends OrderDialogEvent {
  const CloseOrderDialogEvent();
}
class UpdateClientNameEvent extends OrderDialogEvent {
  final String clientName;
  const UpdateClientNameEvent(this.clientName);
  @override
  List<Object?> get props => [clientName];
}
class UpdateOrderTypeEvent extends OrderDialogEvent {
  final String orderType;
  const UpdateOrderTypeEvent(this.orderType);
  @override
  List<Object?> get props => [orderType];
}
class UpdateQuantityEvent extends OrderDialogEvent {
  final int quantity;
  const UpdateQuantityEvent(this.quantity);
  @override
  List<Object?> get props => [quantity];
}
class UpdateLotEvent extends OrderDialogEvent {
  final int lot;
  const UpdateLotEvent(this.lot);
  @override
  List<Object?> get props => [lot];
}
class UpdatePriceEvent extends OrderDialogEvent {
  final double price;
  const UpdatePriceEvent(this.price);
  @override
  List<Object?> get props => [price];
}
class UpdateExchangeEvent extends OrderDialogEvent {
  final String exchange;
  const UpdateExchangeEvent(this.exchange);
  @override
  List<Object?> get props => [exchange];
}
class UpdateSymbolEvent extends OrderDialogEvent {
  final String symbol;
  const UpdateSymbolEvent(this.symbol);
  @override
  List<Object?> get props => [symbol];
}
class IncrementQuantityEvent extends OrderDialogEvent {
  const IncrementQuantityEvent();
}
class DecrementQuantityEvent extends OrderDialogEvent {
  const DecrementQuantityEvent();
}
class IncrementLotEvent extends OrderDialogEvent {
  const IncrementLotEvent();
}
class DecrementLotEvent extends OrderDialogEvent {
  const DecrementLotEvent();
}
class IncrementPriceEvent extends OrderDialogEvent {
  const IncrementPriceEvent();
}
class DecrementPriceEvent extends OrderDialogEvent {
  const DecrementPriceEvent();
}
class SubmitOrderEvent extends OrderDialogEvent {
  const SubmitOrderEvent();
}
class ResetSubmittedEvent extends OrderDialogEvent {
  const ResetSubmittedEvent();
}

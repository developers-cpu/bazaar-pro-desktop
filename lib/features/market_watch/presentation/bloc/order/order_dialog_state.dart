import 'package:equatable/equatable.dart';
import '../../../data/models/order_dialog_type.dart';


class OrderDialogState extends Equatable {
  final OrderDialogTypeEnum dialogType;
  final String clientName;
  final String orderType;
  final int quantity;
  final int lot;
  final double price;
  final String exchange;
  final String symbol;
  final bool isLoading;
  final bool isSubmitted;
  final String? errorMessage;

  const OrderDialogState({
    this.dialogType = OrderDialogTypeEnum.none,
    this.clientName = '',
    this.orderType = '',
    this.quantity = 0,
    this.lot = 0,
    this.price = 0.0,
    this.exchange = '',
    this.symbol = '',
    this.isLoading = false,
    this.isSubmitted = false,
    this.errorMessage,
  });

  bool get isDialogOpen => dialogType != OrderDialogTypeEnum.none;
  bool get isBuyOrder => dialogType == OrderDialogTypeEnum.buy;
  bool get isSellOrder => dialogType == OrderDialogTypeEnum.sell;

  OrderDialogState copyWith({
    OrderDialogTypeEnum? dialogType,
    String? clientName,
    String? orderType,
    int? quantity,
    int? lot,
    double? price,
    String? exchange,
    String? symbol,
    bool? isLoading,
    bool? isSubmitted,
    String? errorMessage,
  }) {
    return OrderDialogState(
      dialogType: dialogType ?? this.dialogType,
      clientName: clientName ?? this.clientName,
      orderType: orderType ?? this.orderType,
      quantity: quantity ?? this.quantity,
      lot: lot ?? this.lot,
      price: price ?? this.price,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    dialogType,
    clientName,
    orderType,
    quantity,
    lot,
    price,
    exchange,
    symbol,
    isLoading,
    isSubmitted,
    errorMessage,
  ];
}
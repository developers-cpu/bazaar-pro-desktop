import 'package:bazarpro/features/users/domain/entities/user_pending_order/user_pending_order.dart';
import 'package:bazarpro/features/users/domain/entities/user_pending_order/user_pending_order_metadata.dart';
import 'package:equatable/equatable.dart';

abstract class UserPendingOrderState extends Equatable {
  const UserPendingOrderState();
  @override
  List<Object?> get props => [];
}

class UserPendingOrderInitial extends UserPendingOrderState {}

class UserPendingOrderLoading extends UserPendingOrderState {}

class UserPendingOrderLoaded extends UserPendingOrderState {
  final List<UserPendingOrder> orders;
  final List<UserPendingOrder> filteredOrders;
  final UserPendingOrderMetadata? metadata;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedOrderType;
  const UserPendingOrderLoaded({
    required this.orders,
    required this.filteredOrders,
    this.metadata,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedOrderType,
  });
  UserPendingOrderLoaded copyWith({
    List<UserPendingOrder>? orders,
    List<UserPendingOrder>? filteredOrders,
    UserPendingOrderMetadata? metadata,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedOrderType,
  }) {
    return UserPendingOrderLoaded(
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      metadata: metadata ?? this.metadata,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    filteredOrders,
    metadata,
    selectedExchange,
    selectedSymbol,
    selectedOrderType,
  ];
}

class UserPendingOrderError extends UserPendingOrderState {
  final String message;
  const UserPendingOrderError(this.message);
  @override
  List<Object> get props => [message];
}
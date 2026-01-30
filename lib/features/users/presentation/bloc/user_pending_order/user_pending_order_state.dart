import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_pending_order.dart';

abstract class UserPendingOrderState extends Equatable {
  const UserPendingOrderState();

  @override
  List<Object?> get props => [];
}

class UserPendingOrderLoading extends UserPendingOrderState {}

class UserPendingOrderLoaded extends UserPendingOrderState {
  final List<UserPendingOrder> orders; // Empty list for now as per screenshot
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedOrderType;

  const UserPendingOrderLoaded({
    this.orders = const [],
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedOrderType,
  });

  UserPendingOrderLoaded copyWith({
    List<UserPendingOrder>? orders,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedOrderType,
  }) {
    return UserPendingOrderLoaded(
      orders: orders ?? this.orders,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    selectedExchange,
    selectedSymbol,
    selectedOrderType,
  ];
}

class UserPendingOrderError extends UserPendingOrderState {
  final String message;
  const UserPendingOrderError(this.message);

  @override
  List<Object?> get props => [message];
}

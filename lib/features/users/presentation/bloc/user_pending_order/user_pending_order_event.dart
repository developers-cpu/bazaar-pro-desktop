import 'package:equatable/equatable.dart';

abstract class UserPendingOrderEvent extends Equatable {
  const UserPendingOrderEvent();
  @override
  List<Object> get props => [];
}

class LoadUserPendingOrders extends UserPendingOrderEvent {
  final String userId;
  const LoadUserPendingOrders(this.userId);
  @override
  List<Object> get props => [userId];
}

class FilterUserPendingOrders extends UserPendingOrderEvent {
  final String? exchange;
  final String? symbol;
  final String? orderType;
  const FilterUserPendingOrders({this.exchange, this.symbol, this.orderType});
  @override
  List<Object> get props => [exchange ?? '', symbol ?? '', orderType ?? ''];
}

import 'package:equatable/equatable.dart';

abstract class UserTradeMarginEvent extends Equatable {
  const UserTradeMarginEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserTradeMargins extends UserTradeMarginEvent {
  final String userId;
  const LoadUserTradeMargins(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FilterUserTradeMargins extends UserTradeMarginEvent {
  final String? exchange;
  final String? symbol;
  final String? searchQuery;

  const FilterUserTradeMargins({this.exchange, this.symbol, this.searchQuery});

  @override
  List<Object?> get props => [exchange, symbol, searchQuery];
}

class ToggleUserTradeMarginSelection extends UserTradeMarginEvent {
  final String id;
  const ToggleUserTradeMarginSelection(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleAllUserTradeMarginSelection extends UserTradeMarginEvent {
  final bool isSelected;
  const ToggleAllUserTradeMarginSelection(this.isSelected);

  @override
  List<Object?> get props => [isSelected];
}

class UpdateUserTradeMargin extends UserTradeMarginEvent {
  final String marginType;
  final double value;

  const UpdateUserTradeMargin({required this.marginType, required this.value});

  @override
  List<Object?> get props => [marginType, value];
}

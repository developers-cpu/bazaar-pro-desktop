import 'package:equatable/equatable.dart';

abstract class UserTradeMarginEvent extends Equatable {
  const UserTradeMarginEvent();
  @override
  List<Object> get props => [];
}

class LoadUserTradeMargin extends UserTradeMarginEvent {
  final String userId;
  const LoadUserTradeMargin(this.userId);
  @override
  List<Object> get props => [userId];
}

class FilterUserTradeMargins extends UserTradeMarginEvent {
  final String? exchange;
  final String? symbol;
  final String? searchQuery;
  const FilterUserTradeMargins({this.exchange, this.symbol, this.searchQuery});
  @override
  List<Object> get props => [exchange ?? '', symbol ?? '', searchQuery ?? ''];
}

class ToggleUserTradeMarginSelection extends UserTradeMarginEvent {
  final String id;
  final bool isSelected;
  const ToggleUserTradeMarginSelection(this.id, this.isSelected);
  @override
  List<Object> get props => [id, isSelected];
}

class ToggleAllUserTradeMarginSelection extends UserTradeMarginEvent {
  final bool isSelected;
  const ToggleAllUserTradeMarginSelection(this.isSelected);
  @override
  List<Object> get props => [isSelected];
}

class UpdateUserTradeMargins extends UserTradeMarginEvent {
  final List<String> selectedIds;
  final double? marginPercentage;
  final double? marginAmount;
  const UpdateUserTradeMargins({
    required this.selectedIds,
    this.marginPercentage,
    this.marginAmount,
  });
  @override
  List<Object> get props => [
    selectedIds,
    if (marginPercentage != null) marginPercentage!,
    if (marginAmount != null) marginAmount!,
  ];
}
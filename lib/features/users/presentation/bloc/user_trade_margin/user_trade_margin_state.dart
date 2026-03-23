import 'package:bazarpro/features/users/domain/entities/user_trade_margin/user_trade_margin.dart';
import 'package:bazarpro/features/users/domain/entities/user_trade_margin/user_trade_margin_metadata.dart';
import 'package:equatable/equatable.dart';

abstract class UserTradeMarginState extends Equatable {
  const UserTradeMarginState();
  @override
  List<Object?> get props => [];
}

class UserTradeMarginInitial extends UserTradeMarginState {}

class UserTradeMarginLoading extends UserTradeMarginState {}

class UserTradeMarginLoaded extends UserTradeMarginState {
  final List<UserTradeMargin> margins;
  final List<UserTradeMargin> filteredMargins;
  final UserTradeMarginMetadata? metadata;
  final bool isAllSelected;
  final String? selectedExchange;
  final String? selectedSymbol;
  const UserTradeMarginLoaded({
    required this.margins,
    required this.filteredMargins,
    this.metadata,
    this.isAllSelected = false,
    this.selectedExchange,
    this.selectedSymbol,
  });
  UserTradeMarginLoaded copyWith({
    List<UserTradeMargin>? margins,
    List<UserTradeMargin>? filteredMargins,
    UserTradeMarginMetadata? metadata,
    bool? isAllSelected,
    String? selectedExchange,
    String? selectedSymbol,
  }) {
    return UserTradeMarginLoaded(
      margins: margins ?? this.margins,
      filteredMargins: filteredMargins ?? this.filteredMargins,
      metadata: metadata ?? this.metadata,
      isAllSelected: isAllSelected ?? this.isAllSelected,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }

  @override
  List<Object?> get props => [
    margins,
    filteredMargins,
    metadata,
    isAllSelected,
    selectedExchange,
    selectedSymbol,
  ];
}

class UserTradeMarginError extends UserTradeMarginState {
  final String message;
  const UserTradeMarginError(this.message);
  @override
  List<Object> get props => [message];
}

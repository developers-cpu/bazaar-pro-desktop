import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_trade_margin.dart';


abstract class UserTradeMarginState extends Equatable {
  const UserTradeMarginState();

  @override
  List<Object?> get props => [];
}

class UserTradeMarginLoading extends UserTradeMarginState {}

class UserTradeMarginLoaded extends UserTradeMarginState {
  final List<UserTradeMargin> allMargins;
  final List<UserTradeMargin> filteredMargins;

  final String? selectedExchange;
  final String? selectedSymbol;
  final String? searchQuery;
  final bool isAllSelected;

  const UserTradeMarginLoaded({
    required this.allMargins,
    required this.filteredMargins,
    this.selectedExchange,
    this.selectedSymbol,
    this.searchQuery,
    this.isAllSelected = false,
  });

  UserTradeMarginLoaded copyWith({
    List<UserTradeMargin>? allMargins,
    List<UserTradeMargin>? filteredMargins,
    String? selectedExchange,
    String? selectedSymbol,
    String? searchQuery,
    bool? isAllSelected,
  }) {
    return UserTradeMarginLoaded(
      allMargins: allMargins ?? this.allMargins,
      filteredMargins: filteredMargins ?? this.filteredMargins,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      searchQuery: searchQuery ?? this.searchQuery,
      isAllSelected: isAllSelected ?? this.isAllSelected,
    );
  }

  @override
  List<Object?> get props => [
    allMargins,
    filteredMargins,
    selectedExchange,
    selectedSymbol,
    searchQuery,
    isAllSelected,
  ];
}

class UserTradeMarginError extends UserTradeMarginState {
  final String message;
  const UserTradeMarginError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:bazarpro/features/view/domain/entities/trade_margin/trade_margin.dart';
import 'package:equatable/equatable.dart';

abstract class TradeMarginState extends Equatable {
  const TradeMarginState();
  @override
  List<Object?> get props => [];
}

class TradeMarginInitial extends TradeMarginState {}

class TradeMarginLoading extends TradeMarginState {}

class TradeMarginLoaded extends TradeMarginState {
  final List<TradeMargin> tradeMargins;
  final String? selectedExchange;
  final String? searchQuery;
  final List<String> exchanges;
  final bool showDialog;
  const TradeMarginLoaded({
    required this.tradeMargins,
    this.selectedExchange,
    this.searchQuery,
    this.showDialog = false,
    this.exchanges = const [
      'NSE',
      'MCX',
      'CE/PE',
      'OTHERS',
      'COMEX',
      'CRYPTO',
      'GIFT',
      'FOREX',
    ],
  });
  TradeMarginLoaded copyWith({
    List<TradeMargin>? tradeMargins,
    String? selectedExchange,
    String? searchQuery,
    bool? showDialog,
  }) {
    return TradeMarginLoaded(
      tradeMargins: tradeMargins ?? this.tradeMargins,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      searchQuery: searchQuery ?? this.searchQuery,
      showDialog: showDialog ?? this.showDialog,
      exchanges: exchanges,
    );
  }

  @override
  List<Object?> get props => [
    tradeMargins,
    selectedExchange,
    searchQuery,
    showDialog,
    exchanges,
  ];
}

class TradeMarginError extends TradeMarginState {
  final String message;
  const TradeMarginError({required this.message});
  @override
  List<Object?> get props => [message];
}
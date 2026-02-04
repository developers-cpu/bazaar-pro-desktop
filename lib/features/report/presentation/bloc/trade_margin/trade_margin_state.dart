import 'package:equatable/equatable.dart';
import '../../../domain/entities/trade_margin.dart';
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
  const TradeMarginLoaded({
    required this.tradeMargins,
    this.selectedExchange,
    this.searchQuery,
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
  }) {
    return TradeMarginLoaded(
      tradeMargins: tradeMargins ?? this.tradeMargins,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      searchQuery: searchQuery ?? this.searchQuery,
      exchanges: exchanges,
    );
  }
  @override
  List<Object?> get props => [
    tradeMargins,
    selectedExchange,
    searchQuery,
    exchanges,
  ];
}
class TradeMarginError extends TradeMarginState {
  final String message;
  const TradeMarginError({required this.message});
  @override
  List<Object?> get props => [message];
}

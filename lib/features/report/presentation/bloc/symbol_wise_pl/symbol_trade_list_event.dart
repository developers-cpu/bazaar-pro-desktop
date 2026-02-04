import 'package:equatable/equatable.dart';

abstract class SymbolTradeListEvent extends Equatable {
  const SymbolTradeListEvent();

  @override
  List<Object?> get props => [];
}

class LoadSymbolTradeList extends SymbolTradeListEvent {
  final String symbol;
  const LoadSymbolTradeList(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

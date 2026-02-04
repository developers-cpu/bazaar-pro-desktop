import 'package:equatable/equatable.dart';

abstract class SymbolWisePLEvent extends Equatable {
  const SymbolWisePLEvent();

  @override
  List<Object?> get props => [];
}

class LoadSymbolWisePL extends SymbolWisePLEvent {
  const LoadSymbolWisePL();
}

class FilterSymbolWisePL extends SymbolWisePLEvent {
  final String? exchange;
  final String? symbol;

  const FilterSymbolWisePL({this.exchange, this.symbol});

  @override
  List<Object?> get props => [exchange, symbol];
}

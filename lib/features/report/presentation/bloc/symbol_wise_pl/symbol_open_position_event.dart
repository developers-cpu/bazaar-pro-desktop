import 'package:equatable/equatable.dart';

abstract class SymbolOpenPositionEvent extends Equatable {
  const SymbolOpenPositionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSymbolOpenPosition extends SymbolOpenPositionEvent {
  final String symbol;
  const LoadSymbolOpenPosition(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

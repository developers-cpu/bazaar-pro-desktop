import 'package:equatable/equatable.dart';
abstract class SymbolOpenPositionEvent extends Equatable {
  const SymbolOpenPositionEvent();
  @override
  List<Object?> get props => [];
}
class LoadSymbolOpenPosition extends SymbolOpenPositionEvent {
  final String? symbol;
  final String? exchange;
  final String? user;
  const LoadSymbolOpenPosition({this.symbol, this.exchange, this.user});
  @override
  List<Object?> get props => [symbol, exchange, user];
}

import 'package:equatable/equatable.dart';
import '../../../domain/entities/symbol_trade_log.dart';

abstract class SymbolTradeListState extends Equatable {
  const SymbolTradeListState();

  @override
  List<Object?> get props => [];
}

class SymbolTradeListInitial extends SymbolTradeListState {}

class SymbolTradeListLoading extends SymbolTradeListState {}

class SymbolTradeListLoaded extends SymbolTradeListState {
  final List<SymbolTradeLog> tradeLogs;
  const SymbolTradeListLoaded(this.tradeLogs);

  @override
  List<Object?> get props => [tradeLogs];
}

class SymbolTradeListError extends SymbolTradeListState {
  final String message;
  const SymbolTradeListError(this.message);

  @override
  List<Object?> get props => [message];
}

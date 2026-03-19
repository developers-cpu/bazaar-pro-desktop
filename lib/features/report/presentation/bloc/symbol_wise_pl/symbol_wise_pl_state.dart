import 'package:equatable/equatable.dart';
import '../../../domain/entities/symbol_wise_pl/symbol_wise_pl_report.dart';

abstract class SymbolWisePLState extends Equatable {
  const SymbolWisePLState();
  @override
  List<Object?> get props => [];
}

class SymbolWisePLInitial extends SymbolWisePLState {}

class SymbolWisePLLoading extends SymbolWisePLState {}

class SymbolWisePLLoaded extends SymbolWisePLState {
  final List<SymbolWisePLReport> reports;
  final List<String> exchanges;
  final List<String> symbols;
  final String? selectedExchange;
  final String? selectedSymbol;
  const SymbolWisePLLoaded({
    required this.reports,
    this.exchanges = const [],
    this.symbols = const [],
    this.selectedExchange,
    this.selectedSymbol,
  });
  SymbolWisePLLoaded copyWith({
    List<SymbolWisePLReport>? reports,
    List<String>? exchanges,
    List<String>? symbols,
    String? selectedExchange,
    String? selectedSymbol,
  }) {
    return SymbolWisePLLoaded(
      reports: reports ?? this.reports,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }

  @override
  List<Object?> get props => [
    reports,
    exchanges,
    symbols,
    selectedExchange,
    selectedSymbol,
  ];
}

class SymbolWisePLError extends SymbolWisePLState {
  final String message;
  const SymbolWisePLError({required this.message});
  @override
  List<Object?> get props => [message];
}
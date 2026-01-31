import 'package:bazarpro/features/report/domain/entities/symbol_wise_position_report.dart';
import 'package:equatable/equatable.dart';

abstract class SymbolWisePositionReportState extends Equatable {
  const SymbolWisePositionReportState();

  @override
  List<Object?> get props => [];
}

class SymbolWisePositionReportInitial extends SymbolWisePositionReportState {}

class SymbolWisePositionReportLoading extends SymbolWisePositionReportState {}

class SymbolWisePositionReportLoaded extends SymbolWisePositionReportState {
  final List<SymbolWisePositionReport> reports;
  final List<String> exchanges;
  final List<String> symbols;
  final String? selectedExchange;
  final String? selectedSymbol;

  const SymbolWisePositionReportLoaded({
    required this.reports,
    this.exchanges = const [],
    this.symbols = const [],
    this.selectedExchange,
    this.selectedSymbol,
  });

  SymbolWisePositionReportLoaded copyWith({
    List<SymbolWisePositionReport>? reports,
    List<String>? exchanges,
    List<String>? symbols,
    String? selectedExchange,
    String? selectedSymbol,
  }) {
    return SymbolWisePositionReportLoaded(
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

class SymbolWisePositionReportError extends SymbolWisePositionReportState {
  final String message;

  const SymbolWisePositionReportError({required this.message});

  @override
  List<Object> get props => [message];
}

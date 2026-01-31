import 'package:equatable/equatable.dart';

abstract class SymbolWisePositionReportEvent extends Equatable {
  const SymbolWisePositionReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadSymbolWisePositionReport extends SymbolWisePositionReportEvent {
  const LoadSymbolWisePositionReport();
}

class FilterSymbolWisePositionReport extends SymbolWisePositionReportEvent {
  final String? exchange;
  final String? symbol;

  const FilterSymbolWisePositionReport({this.exchange, this.symbol});

  @override
  List<Object?> get props => [exchange, symbol];
}

class ResetSymbolWisePositionReportFilters
    extends SymbolWisePositionReportEvent {
  const ResetSymbolWisePositionReportFilters();
}

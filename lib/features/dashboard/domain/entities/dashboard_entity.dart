import 'package:equatable/equatable.dart';

class TradeReportData extends Equatable {
  final String date;
  final double deleted;
  final double cancelled;
  final double success;
  const TradeReportData({
    required this.date,
    required this.deleted,
    required this.cancelled,
    required this.success,
  });
  @override
  List<Object?> get props => [date, deleted, cancelled, success];
}

class SymbolReportData extends Equatable {
  final String symbol;
  final double value;
  final double percentage;
  final int colorIndex;
  const SymbolReportData({
    required this.symbol,
    required this.value,
    required this.percentage,
    required this.colorIndex,
  });
  @override
  List<Object?> get props => [symbol, value, percentage, colorIndex];
}

class DashboardSummary extends Equatable {
  final double pnl;
  final double bk;
  final double other;
  final double balance;
  const DashboardSummary({
    required this.pnl,
    required this.bk,
    required this.other,
    required this.balance,
  });
  @override
  List<Object?> get props => [pnl, bk, other, balance];
}

class WeeklyProgressData extends Equatable {
  final String label;
  final double value;
  const WeeklyProgressData({required this.label, required this.value});
  @override
  List<Object?> get props => [label, value];
}

class DashboardData extends Equatable {
  final List<TradeReportData> tradeReports;
  final List<SymbolReportData> symbolReports;
  final List<WeeklyProgressData> weeklyProgress;
  final DashboardSummary summary;
  const DashboardData({
    required this.tradeReports,
    required this.symbolReports,
    required this.weeklyProgress,
    required this.summary,
  });
  @override
  List<Object?> get props => [
    tradeReports,
    symbolReports,
    weeklyProgress,
    summary,
  ];
}


import '../../domain/entities/dashboard_entity.dart';

class TradeReportModel extends TradeReportData {
  const TradeReportModel({
    required super.date,
    required super.deleted,
    required super.cancelled,
    required super.success,
  });

  factory TradeReportModel.fromJson(Map<String, dynamic> json) {
    return TradeReportModel(
      date: json['date'] as String,
      deleted: (json['deleted'] as num).toDouble(),
      cancelled: (json['cancelled'] as num).toDouble(),
      success: (json['success'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'deleted': deleted,
      'cancelled': cancelled,
      'success': success,
    };
  }
}

class SymbolReportModel extends SymbolReportData {
  const SymbolReportModel({
    required super.symbol,
    required super.value,
    required super.percentage,
    required super.colorIndex,
  });

  factory SymbolReportModel.fromJson(Map<String, dynamic> json, int index) {
    return SymbolReportModel(
      symbol: json['symbol'] as String,
      value: (json['value'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      colorIndex: index,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'value': value,
      'percentage': percentage,
    };
  }
}

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.pnl,
    required super.bk,
    required super.other,
    required super.balance,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      pnl: (json['pnl'] as num).toDouble(),
      bk: (json['bk'] as num).toDouble(),
      other: (json['other'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pnl': pnl,
      'bk': bk,
      'other': other,
      'balance': balance,
    };
  }
}
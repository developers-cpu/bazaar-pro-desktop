import '../../../domain/entities/bill_comparison/bill_comparison_entity.dart';

class BillComparisonModel extends BillComparisonEntity {
  const BillComparisonModel({
    required super.index,
    required super.username,
    required super.billTotal,
    required super.billBrokerage,
    required super.billNetTotal,
    required super.settlementTotal,
    required super.settlementBrokerage,
    required super.settlementNetTotal,
    required super.type,
  });
  factory BillComparisonModel.fromJson(Map<String, dynamic> json, int index) {
    return BillComparisonModel(
      index: index,
      username: json['username']?.toString() ?? '',
      billTotal: json['billTotal']?.toString() ?? '0',
      billBrokerage: json['billBrokerage']?.toString() ?? '0',
      billNetTotal: json['billNetTotal']?.toString() ?? '0',
      settlementTotal: json['settlementTotal']?.toString() ?? '0',
      settlementBrokerage: json['settlementBrokerage']?.toString() ?? '0',
      settlementNetTotal: json['settlementNetTotal']?.toString() ?? '0',
      type: json['type']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'billTotal': billTotal,
      'billBrokerage': billBrokerage,
      'billNetTotal': billNetTotal,
      'settlementTotal': settlementTotal,
      'settlementBrokerage': settlementBrokerage,
      'settlementNetTotal': settlementNetTotal,
      'type': type,
    };
  }
}
import '../../../domain/entities/surveillance/surveillance_bulk_order.dart';

class SurveillanceBulkOrderModel extends SurveillanceBulkOrder {
  const SurveillanceBulkOrderModel({
    required super.id,
    required super.exchange,
    required super.symbol,
    required super.intervalTime,
    required super.totalQuantity,
    required super.tradeSlLimit,
    required super.updatedOn,
    required super.updatedBy,
  });
  factory SurveillanceBulkOrderModel.fromJson(Map<String, dynamic> json) {
    return SurveillanceBulkOrderModel(
      id: json['id'] ?? '',
      exchange: json['exchange'] ?? '',
      symbol: json['symbol'] ?? '',
      intervalTime: json['intervalTime'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
      tradeSlLimit: (json['tradeSlLimit'] ?? 0.0).toDouble(),
      updatedOn: json['updatedOn'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'symbol': symbol,
      'intervalTime': intervalTime,
      'totalQuantity': totalQuantity,
      'tradeSlLimit': tradeSlLimit,
      'updatedOn': updatedOn,
      'updatedBy': updatedBy,
    };
  }

  factory SurveillanceBulkOrderModel.fromEntity(SurveillanceBulkOrder entity) {
    return SurveillanceBulkOrderModel(
      id: entity.id,
      exchange: entity.exchange,
      symbol: entity.symbol,
      intervalTime: entity.intervalTime,
      totalQuantity: entity.totalQuantity,
      tradeSlLimit: entity.tradeSlLimit,
      updatedOn: entity.updatedOn,
      updatedBy: entity.updatedBy,
    );
  }
}
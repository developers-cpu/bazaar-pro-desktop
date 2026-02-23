import '../../../domain/entities/script_quantity/script_quantity.dart';
class ScriptQuantityModel extends ScriptQuantity {
  const ScriptQuantityModel({
    required super.id,
    required super.symbol,
    required super.breakupQty,
    required super.maxQty,
  });
  factory ScriptQuantityModel.fromJson(Map<String, dynamic> json) {
    return ScriptQuantityModel(
      id: json['id']?.toString() ?? '',
      symbol: json['symbol'] ?? '',
      breakupQty: (json['breakupQty'] ?? json['breakup_qty'] ?? 0).toDouble(),
      maxQty: (json['maxQty'] ?? json['max_qty'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'breakupQty': breakupQty,
      'maxQty': maxQty,
    };
  }
  factory ScriptQuantityModel.fromEntity(ScriptQuantity scriptQuantity) {
    return ScriptQuantityModel(
      id: scriptQuantity.id,
      symbol: scriptQuantity.symbol,
      breakupQty: scriptQuantity.breakupQty,
      maxQty: scriptQuantity.maxQty,
    );
  }
}

import 'package:equatable/equatable.dart';


class ScriptQuantity extends Equatable {
  final String id;
  final String symbol;
  final double breakupQty;
  final double maxQty;

  const ScriptQuantity({
    required this.id,
    required this.symbol,
    required this.breakupQty,
    required this.maxQty,
  });

  @override
  List<Object?> get props => [id, symbol, breakupQty, maxQty];

  ScriptQuantity copyWith({
    String? id,
    String? symbol,
    double? breakupQty,
    double? maxQty,
  }) {
    return ScriptQuantity(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      breakupQty: breakupQty ?? this.breakupQty,
      maxQty: maxQty ?? this.maxQty,
    );
  }
}
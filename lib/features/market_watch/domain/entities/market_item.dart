import 'package:equatable/equatable.dart';

class MarketItem extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final int buyQty;
  final double buyPrice;
  final double sellPrice;
  final int sellQty;
  final double netChange;
  final double high;
  final double low;
  final double open;
  final double close;
  final double ltp;
  final double netChangePercent;
  final DateTime? expiry;
  final double strikePrice;
  final double lowerCkt;
  final double upperCkt;
  final int tbq;
  final int tsq;
  final DateTime lut;
  const MarketItem({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.buyQty,
    required this.buyPrice,
    required this.sellPrice,
    required this.sellQty,
    required this.netChange,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
    required this.ltp,
    required this.netChangePercent,
    this.expiry,
    required this.strikePrice,
    required this.lowerCkt,
    required this.upperCkt,
    required this.tbq,
    required this.tsq,
    required this.lut,
  });
  MarketItem copyWith({
    String? id,
    String? exchange,
    String? symbol,
    int? buyQty,
    double? buyPrice,
    double? sellPrice,
    int? sellQty,
    double? netChange,
    double? high,
    double? low,
    double? open,
    double? close,
    double? ltp,
    double? netChangePercent,
    DateTime? expiry,
    double? strikePrice,
    double? lowerCkt,
    double? upperCkt,
    int? tbq,
    int? tsq,
    DateTime? lut,
  }) {
    return MarketItem(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      buyQty: buyQty ?? this.buyQty,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      sellQty: sellQty ?? this.sellQty,
      netChange: netChange ?? this.netChange,
      high: high ?? this.high,
      low: low ?? this.low,
      open: open ?? this.open,
      close: close ?? this.close,
      ltp: ltp ?? this.ltp,
      netChangePercent: netChangePercent ?? this.netChangePercent,
      expiry: expiry ?? this.expiry,
      strikePrice: strikePrice ?? this.strikePrice,
      lowerCkt: lowerCkt ?? this.lowerCkt,
      upperCkt: upperCkt ?? this.upperCkt,
      tbq: tbq ?? this.tbq,
      tsq: tsq ?? this.tsq,
      lut: lut ?? this.lut,
    );
  }

  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    buyQty,
    buyPrice,
    sellPrice,
    sellQty,
    netChange,
    high,
    low,
    open,
    close,
    ltp,
    netChangePercent,
    expiry,
    strikePrice,
    lowerCkt,
    upperCkt,
    tbq,
    tsq,
    lut,
  ];
}

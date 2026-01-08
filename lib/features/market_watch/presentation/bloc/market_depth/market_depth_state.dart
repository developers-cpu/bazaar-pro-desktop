import 'package:equatable/equatable.dart';

class MarketDepthState extends Equatable {
  final bool isOpen;
  final String exchange;
  final String symbol;
  final bool isLoading;
  final MarketDepthData? marketDepthData;
  final String? errorMessage;

  const MarketDepthState({
    this.isOpen = false,
    this.exchange = '',
    this.symbol = '',
    this.isLoading = false,
    this.marketDepthData,
    this.errorMessage,
  });

  MarketDepthState copyWith({
    bool? isOpen,
    String? exchange,
    String? symbol,
    bool? isLoading,
    MarketDepthData? marketDepthData,
    String? errorMessage,
  }) {
    return MarketDepthState(
      isOpen: isOpen ?? this.isOpen,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      isLoading: isLoading ?? this.isLoading,
      marketDepthData: marketDepthData ?? this.marketDepthData,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isOpen,
    exchange,
    symbol,
    isLoading,
    marketDepthData,
    errorMessage,
  ];
}

// Market Depth Data Model
class MarketDepthData extends Equatable {
  final int lotSize;
  final double ltp;
  final int volume;
  final double avgPrice;
  final double lCrkt;
  final double open;
  final double high;
  final double low;
  final double close;
  final double uCrkt;
  final List<MarketDepthRow> bidRows;
  final List<MarketDepthRow> askRows;

  const MarketDepthData({
    this.lotSize = 35,
    this.ltp = 60013,
    this.volume = 422590,
    this.avgPrice = 52402,
    this.lCrkt = 80254,
    this.open = 35,
    this.high = 60013,
    this.low = 422590,
    this.close = 52402,
    this.uCrkt = 80254,
    this.bidRows = const [],
    this.askRows = const [],
  });

  int get totalBidQty => bidRows.fold(0, (sum, row) => sum + row.qty);
  int get totalAskQty => askRows.fold(0, (sum, row) => sum + row.qty);

  @override
  List<Object?> get props => [
    lotSize,
    ltp,
    volume,
    avgPrice,
    lCrkt,
    open,
    high,
    low,
    close,
    uCrkt,
    bidRows,
    askRows,
  ];
}

class MarketDepthRow extends Equatable {
  final double price;
  final int orders;
  final int qty;

  const MarketDepthRow({
    required this.price,
    required this.orders,
    required this.qty,
  });

  @override
  List<Object?> get props => [price, orders, qty];
}

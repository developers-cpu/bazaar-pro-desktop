import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== EVENTS ====================
abstract class MarketDepthEvent extends Equatable {
  const MarketDepthEvent();

  @override
  List<Object?> get props => [];
}

class OpenMarketDepthEvent extends MarketDepthEvent {
  final String? exchange;
  final String? symbol;

  const OpenMarketDepthEvent({this.exchange, this.symbol});

  @override
  List<Object?> get props => [exchange, symbol];
}

class CloseMarketDepthEvent extends MarketDepthEvent {
  const CloseMarketDepthEvent();
}

class UpdateExchangeEvent extends MarketDepthEvent {
  final String exchange;

  const UpdateExchangeEvent(this.exchange);

  @override
  List<Object?> get props => [exchange];
}

class UpdateSymbolEvent extends MarketDepthEvent {
  final String symbol;

  const UpdateSymbolEvent(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

class RefreshMarketDepthEvent extends MarketDepthEvent {
  const RefreshMarketDepthEvent();
}

// ==================== STATE ====================
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

// ==================== BLOC ====================
class MarketDepthBloc extends Bloc<MarketDepthEvent, MarketDepthState> {
  MarketDepthBloc() : super(const MarketDepthState()) {
    on<OpenMarketDepthEvent>(_onOpenMarketDepth);
    on<CloseMarketDepthEvent>(_onCloseMarketDepth);
    on<UpdateExchangeEvent>(_onUpdateExchange);
    on<UpdateSymbolEvent>(_onUpdateSymbol);
    on<RefreshMarketDepthEvent>(_onRefreshMarketDepth);
  }

  void _onOpenMarketDepth(
      OpenMarketDepthEvent event, Emitter<MarketDepthState> emit) {
    // Sample market depth data
    final sampleData = MarketDepthData(
      lotSize: 35,
      ltp: 60013,
      volume: 422590,
      avgPrice: 52402,
      lCrkt: 80254,
      open: 35,
      high: 60013,
      low: 422590,
      close: 52402,
      uCrkt: 80254,
      bidRows: const [
        MarketDepthRow(price: 25639, orders: 2, qty: 2),
        MarketDepthRow(price: 25638, orders: 1, qty: 1),
        MarketDepthRow(price: 25637, orders: 1, qty: 1),
        MarketDepthRow(price: 25636, orders: 5, qty: 5),
        MarketDepthRow(price: 25635, orders: 2, qty: 2),
      ],
      askRows: const [
        MarketDepthRow(price: 25640, orders: 2, qty: 2),
        MarketDepthRow(price: 25641, orders: 1, qty: 1),
        MarketDepthRow(price: 25642, orders: 1, qty: 1),
        MarketDepthRow(price: 25643, orders: 5, qty: 5),
        MarketDepthRow(price: 25644, orders: 2, qty: 2),
      ],
    );

    emit(MarketDepthState(
      isOpen: true,
      exchange: event.exchange ?? 'MCX',
      symbol: event.symbol ?? 'NIFTY25NOV25',
      marketDepthData: sampleData,
    ));
  }

  void _onCloseMarketDepth(
      CloseMarketDepthEvent event, Emitter<MarketDepthState> emit) {
    emit(const MarketDepthState());
  }

  void _onUpdateExchange(
      UpdateExchangeEvent event, Emitter<MarketDepthState> emit) {
    emit(state.copyWith(exchange: event.exchange));
    // Optionally refresh data when exchange changes
    add(const RefreshMarketDepthEvent());
  }

  void _onUpdateSymbol(
      UpdateSymbolEvent event, Emitter<MarketDepthState> emit) {
    emit(state.copyWith(symbol: event.symbol));
    // Optionally refresh data when symbol changes
    add(const RefreshMarketDepthEvent());
  }

  void _onRefreshMarketDepth(
      RefreshMarketDepthEvent event, Emitter<MarketDepthState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate new sample data (in real app, fetch from API)
    final sampleData = MarketDepthData(
      lotSize: 35,
      ltp: 60013,
      volume: 422590,
      avgPrice: 52402,
      lCrkt: 80254,
      open: 35,
      high: 60013,
      low: 422590,
      close: 52402,
      uCrkt: 80254,
      bidRows: const [
        MarketDepthRow(price: 25639, orders: 2, qty: 2),
        MarketDepthRow(price: 25638, orders: 1, qty: 1),
        MarketDepthRow(price: 25637, orders: 1, qty: 1),
        MarketDepthRow(price: 25636, orders: 5, qty: 5),
        MarketDepthRow(price: 25635, orders: 2, qty: 2),
      ],
      askRows: const [
        MarketDepthRow(price: 25640, orders: 2, qty: 2),
        MarketDepthRow(price: 25641, orders: 1, qty: 1),
        MarketDepthRow(price: 25642, orders: 1, qty: 1),
        MarketDepthRow(price: 25643, orders: 5, qty: 5),
        MarketDepthRow(price: 25644, orders: 2, qty: 2),
      ],
    );

    emit(state.copyWith(isLoading: false, marketDepthData: sampleData));
  }
}
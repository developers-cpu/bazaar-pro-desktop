import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_depth_event.dart';
import 'market_depth_state.dart';
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
    add(const RefreshMarketDepthEvent());
  }
  void _onUpdateSymbol(
      UpdateSymbolEvent event, Emitter<MarketDepthState> emit) {
    emit(state.copyWith(symbol: event.symbol));
    add(const RefreshMarketDepthEvent());
  }
  void _onRefreshMarketDepth(
      RefreshMarketDepthEvent event, Emitter<MarketDepthState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
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

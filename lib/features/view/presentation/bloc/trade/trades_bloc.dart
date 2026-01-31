import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/trades/trade.dart';
import '../../../domain/usecases/trade/trades_usecases.dart';
import 'trades_event.dart';
import 'trades_state.dart';

class TradesBloc extends Bloc<TradesEvent, TradesState> {
  final GetTrades getTrades;
  final GetTradesWithFilters getTradesWithFilters;
  final GetTradesClients getClients;
  final GetTradesExchanges getExchanges;
  final GetTradesSymbols getSymbols;
  final GetTradesOrderTypes getOrderTypes;
  final ExportTradesToPdf exportToPdf;
  final ExportTradesToExcel exportToExcel;

  TradesBloc({
    required this.getTrades,
    required this.getTradesWithFilters,
    required this.getClients,
    required this.getExchanges,
    required this.getSymbols,
    required this.getOrderTypes,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const TradesInitial()) {
    on<LoadTradesEvent>(_onLoadTrades);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ResetFiltersEvent>(_onResetFilters);
    on<SelectTradeEvent>(_onSelectTrade);
    on<SortTradesByColumnEvent>(_onSortByColumn);
    on<ExportTradesToPdfEvent>(_onExportToPdf);
    on<ExportTradesToExcelEvent>(_onExportToExcel);
  }

  Future<void> _onLoadTrades(
      LoadTradesEvent event,
      Emitter<TradesState> emit,
      ) async {
    emit(const TradesLoading());

    try {

      final results = await Future.wait([
        getTrades(NoParams()),
        getClients(NoParams()),
        getExchanges(NoParams()),
        getSymbols(NoParams()),
        getOrderTypes(NoParams()),
      ]);

      final tradesResult = results[0];
      final clientsResult = results[1];
      final exchangesResult = results[2];
      final symbolsResult = results[3];
      final orderTypesResult = results[4];

      if (tradesResult.isLeft()) {
        final failure = tradesResult.fold((l) => l, (r) => null);
        emit(TradesError(failure?.message ?? 'Failed to load trades'));
        return;
      }

      final trades = tradesResult.fold((l) => <Trade>[], (r) => r as List<Trade>);
      final clients = clientsResult.fold((l) => <String>[], (r) => r as List<String>);
      final exchanges = exchangesResult.fold((l) => <String>[], (r) => r as List<String>);
      final symbols = symbolsResult.fold((l) => <String>[], (r) => r as List<String>);
      final orderTypes = orderTypesResult.fold((l) => <String>[], (r) => r as List<String>);

      emit(TradesLoaded(
        trades: trades,
        filteredTrades: trades,
        totalRecords: trades.length,
        clients: clients,
        exchanges: exchanges,
        symbols: symbols,
        orderTypes: orderTypes,
      ));
    } catch (e) {
      emit(TradesError(e.toString()));
    }
  }

  Future<void> _onApplyFilters(
      ApplyFiltersEvent event,
      Emitter<TradesState> emit,
      ) async {
    if (state is! TradesLoaded) return;

    final currentState = state as TradesLoaded;
    emit(const TradesLoading());

    final result = await getTradesWithFilters(TradesFilterParams(
      startDate: event.startDate,
      endDate: event.endDate,
      client: event.client,
      exchange: event.exchange,
      symbol: event.symbol,
      orderType: event.orderType,
    ));

    result.fold(
          (failure) => emit(TradesError(failure.message)),
          (trades) => emit(currentState.copyWith(
        filteredTrades: trades,
        totalRecords: trades.length,
        startDate: event.startDate,
        endDate: event.endDate,
        selectedClient: event.client,
        selectedExchange: event.exchange,
        selectedSymbol: event.symbol,
        selectedOrderType: event.orderType,
      )),
    );
  }

  Future<void> _onResetFilters(
      ResetFiltersEvent event,
      Emitter<TradesState> emit,
      ) async {
    if (state is! TradesLoaded) return;

    final currentState = state as TradesLoaded;

    emit(TradesLoaded(
      trades: currentState.trades,
      filteredTrades: currentState.trades,
      totalRecords: currentState.trades.length,
      clients: currentState.clients,
      exchanges: currentState.exchanges,
      symbols: currentState.symbols,
      orderTypes: currentState.orderTypes,
    ));
  }

  void _onSelectTrade(
      SelectTradeEvent event,
      Emitter<TradesState> emit,
      ) {
    if (state is! TradesLoaded) return;

    final currentState = state as TradesLoaded;
    emit(currentState.copyWith(selectedTradeId: event.tradeId));
  }

  void _onSortByColumn(
      SortTradesByColumnEvent event,
      Emitter<TradesState> emit,
      ) {
    if (state is! TradesLoaded) return;

    final currentState = state as TradesLoaded;
    final sortedTrades = List<Trade>.from(currentState.filteredTrades);

    sortedTrades.sort((a, b) {
      int comparison = 0;
      switch (event.columnId) {
        case 'userName':
          comparison = a.userName.compareTo(b.userName);
          break;
        case 'pUser':
          comparison = a.pUser.compareTo(b.pUser);
          break;
        case 'exchange':
          comparison = a.exchange.compareTo(b.exchange);
          break;
        case 'symbol':
          comparison = a.symbol.compareTo(b.symbol);
          break;
        case 'orderDateTime':
          comparison = a.orderDateTime.compareTo(b.orderDateTime);
          break;
        case 'buySell':
          comparison = a.buySell.compareTo(b.buySell);
          break;
        case 'qty':
          comparison = a.qty.compareTo(b.qty);
          break;
        case 'lot':
          comparison = a.lot.compareTo(b.lot);
          break;
        case 'orderType':
          comparison = a.orderType.compareTo(b.orderType);
          break;
        case 'pl':
          comparison = a.pl.compareTo(b.pl);
          break;
        case 'triggerPrice':
          comparison = a.triggerPrice.compareTo(b.triggerPrice);
          break;
        case 'brokerage':
          comparison = a.brokerage.compareTo(b.brokerage);
          break;
        case 'rPrice':
          comparison = a.rPrice.compareTo(b.rPrice);
          break;
        default:
          comparison = 0;
      }
      return event.ascending ? comparison : -comparison;
    });

    emit(currentState.copyWith(
      filteredTrades: sortedTrades,
      sortColumn: event.columnId,
      sortAscending: event.ascending,
    ));
  }

  Future<void> _onExportToPdf(
      ExportTradesToPdfEvent event,
      Emitter<TradesState> emit,
      ) async {
    if (state is! TradesLoaded) return;

    final currentState = state as TradesLoaded;

    final result = await exportToPdf(currentState.filteredTrades);

    result.fold(
          (failure) => emit(TradesError(failure.message)),
          (path) {
        emit(TradesExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ));

        emit(currentState);
      },
    );
  }

  Future<void> _onExportToExcel(
      ExportTradesToExcelEvent event,
      Emitter<TradesState> emit,
      ) async {
    if (state is! TradesLoaded) return;

    final currentState = state as TradesLoaded;

    final result = await exportToExcel(currentState.filteredTrades);

    result.fold(
          (failure) => emit(TradesError(failure.message)),
          (path) {
        emit(TradesExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ));

        emit(currentState);
      },
    );
  }
}
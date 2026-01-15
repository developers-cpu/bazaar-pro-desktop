import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/pending_order.dart';
import 'pending_orders_event.dart';
import 'pending_orders_state.dart';

/// Pending Orders BLoC
class PendingOrdersBloc extends Bloc<PendingOrdersEvent, PendingOrdersState> {
  PendingOrdersBloc() : super(const PendingOrdersInitial()) {
    on<LoadPendingOrdersEvent>(_onLoadPendingOrders);
    on<FilterByClientEvent>(_onFilterByClient);
    on<FilterByExchangeEvent>(_onFilterByExchange);
    on<FilterBySymbolEvent>(_onFilterBySymbol);
    on<FilterByTypeEvent>(_onFilterByType);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ResetFiltersEvent>(_onResetFilters);
    on<SortByColumnEvent>(_onSortByColumn);
    on<ExportToPdfEvent>(_onExportToPdf);
    on<ExportToExcelEvent>(_onExportToExcel);
    on<SelectOrderEvent>(_onSelectOrder);
  }

  Future<void> _onLoadPendingOrders(
      LoadPendingOrdersEvent event,
      Emitter<PendingOrdersState> emit,
      ) async {
    emit(const PendingOrdersLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final orders = _generateDummyOrders();
      final clients = _extractUniqueValues(orders, (o) => o.userId);
      final exchanges = _extractUniqueValues(orders, (o) => o.exchange);
      final symbols = _extractUniqueValues(orders, (o) => o.symbol);
      final types = ['All', 'Buy', 'Sell', 'Buy Limit', 'Buy Stop', 'Sell Limit', 'Sell Stop'];

      emit(PendingOrdersLoaded(
        allOrders: orders,
        filteredOrders: orders,
        clients: clients,
        exchanges: exchanges,
        symbols: symbols,
        types: types,
        totalRecords: orders.length,
      ));
    } catch (e) {
      emit(PendingOrdersError(e.toString()));
    }
  }

  void _onFilterByClient(
      FilterByClientEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final filtered = _applyFilters(
        currentState.allOrders,
        client: event.client,
        exchange: currentState.selectedExchange,
        symbol: currentState.selectedSymbol,
        type: currentState.selectedType,
      );

      emit(currentState.copyWith(
        selectedClient: event.client,
        filteredOrders: filtered,
        totalRecords: filtered.length,
        clearClient: event.client == null || event.client!.isEmpty,
      ));
    }
  }

  void _onFilterByExchange(
      FilterByExchangeEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final filtered = _applyFilters(
        currentState.allOrders,
        client: currentState.selectedClient,
        exchange: event.exchange,
        symbol: currentState.selectedSymbol,
        type: currentState.selectedType,
      );

      emit(currentState.copyWith(
        selectedExchange: event.exchange,
        filteredOrders: filtered,
        totalRecords: filtered.length,
        clearExchange: event.exchange == null || event.exchange!.isEmpty,
      ));
    }
  }

  void _onFilterBySymbol(
      FilterBySymbolEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final filtered = _applyFilters(
        currentState.allOrders,
        client: currentState.selectedClient,
        exchange: currentState.selectedExchange,
        symbol: event.symbol,
        type: currentState.selectedType,
      );

      emit(currentState.copyWith(
        selectedSymbol: event.symbol,
        filteredOrders: filtered,
        totalRecords: filtered.length,
        clearSymbol: event.symbol == null || event.symbol!.isEmpty,
      ));
    }
  }

  void _onFilterByType(
      FilterByTypeEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final filtered = _applyFilters(
        currentState.allOrders,
        client: currentState.selectedClient,
        exchange: currentState.selectedExchange,
        symbol: currentState.selectedSymbol,
        type: event.type,
      );

      emit(currentState.copyWith(
        selectedType: event.type,
        filteredOrders: filtered,
        totalRecords: filtered.length,
        clearType: event.type == null || event.type!.isEmpty || event.type == 'All',
      ));
    }
  }

  void _onApplyFilters(
      ApplyFiltersEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final filtered = _applyFilters(
        currentState.allOrders,
        client: event.client,
        exchange: event.exchange,
        symbol: event.symbol,
        type: event.type,
      );

      emit(currentState.copyWith(
        selectedClient: event.client,
        selectedExchange: event.exchange,
        selectedSymbol: event.symbol,
        selectedType: event.type,
        filteredOrders: filtered,
        totalRecords: filtered.length,
      ));
    }
  }

  void _onResetFilters(
      ResetFiltersEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      emit(PendingOrdersLoaded(
        allOrders: currentState.allOrders,
        filteredOrders: currentState.allOrders,
        clients: currentState.clients,
        exchanges: currentState.exchanges,
        symbols: currentState.symbols,
        types: currentState.types,
        totalRecords: currentState.allOrders.length,
      ));
    }
  }

  void _onSortByColumn(
      SortByColumnEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final sorted = List<PendingOrder>.from(currentState.filteredOrders);

      sorted.sort((a, b) {
        int comparison = 0;
        switch (event.columnId) {
          case 'userId':
            comparison = a.userId.compareTo(b.userId);
            break;
          case 'upline':
            comparison = a.upline.compareTo(b.upline);
            break;
          case 'exchange':
            comparison = a.exchange.compareTo(b.exchange);
            break;
          case 'symbol':
            comparison = a.symbol.compareTo(b.symbol);
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
          case 'triggerPrice':
            comparison = a.triggerPrice.compareTo(b.triggerPrice);
            break;
          case 'orderDateTime':
            comparison = a.orderDateTime.compareTo(b.orderDateTime);
            break;
          case 'modifyOrderDateTime':
            comparison = a.modifyOrderDateTime.compareTo(b.modifyOrderDateTime);
            break;
          case 'orderType':
            comparison = a.orderType.compareTo(b.orderType);
            break;
          case 'cmp':
            comparison = a.cmp.compareTo(b.cmp);
            break;
          case 'rPrice':
            comparison = a.rPrice.compareTo(b.rPrice);
            break;
        }
        return event.ascending ? comparison : -comparison;
      });

      emit(currentState.copyWith(
        filteredOrders: sorted,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ));
    }
  }

  Future<void> _onExportToPdf(
      ExportToPdfEvent event,
      Emitter<PendingOrdersState> emit,
      ) async {

    emit(const PendingOrdersExporting('pdf'));
    await Future.delayed(const Duration(seconds: 1));
    emit(const PendingOrdersExportSuccess(
      message: 'PDF exported successfully',
      filePath: '/downloads/pending_orders.pdf',
    ));


    if (state is PendingOrdersLoaded) {
      emit(state);
    }
  }

  Future<void> _onExportToExcel(
      ExportToExcelEvent event,
      Emitter<PendingOrdersState> emit,
      ) async {

    emit(const PendingOrdersExporting('excel'));
    await Future.delayed(const Duration(seconds: 1));
    emit(const PendingOrdersExportSuccess(
      message: 'Excel exported successfully',
      filePath: '/downloads/pending_orders.xlsx',
    ));

    // Restore previous state
    if (state is PendingOrdersLoaded) {
      emit(state);
    }
  }

  void _onSelectOrder(
      SelectOrderEvent event,
      Emitter<PendingOrdersState> emit,
      ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      emit(currentState.copyWith(selectedOrderId: event.orderId));
    }
  }


  List<PendingOrder> _applyFilters(
      List<PendingOrder> orders, {
        String? client,
        String? exchange,
        String? symbol,
        String? type,
      }) {
    return orders.where((order) {
      if (client != null && client.isNotEmpty && order.userId != client) {
        return false;
      }
      if (exchange != null && exchange.isNotEmpty && order.exchange != exchange) {
        return false;
      }
      if (symbol != null && symbol.isNotEmpty && order.symbol != symbol) {
        return false;
      }
      if (type != null && type.isNotEmpty && type != 'All') {
        if (!order.buySell.toLowerCase().contains(type.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<String> _extractUniqueValues(
      List<PendingOrder> orders,
      String Function(PendingOrder) extractor,
      ) {
    return orders.map(extractor).toSet().toList()..sort();
  }

  /// Generate dummy orders for testing
  List<PendingOrder> _generateDummyOrders() {
    final List<String> users = ['PATIL', 'DEMO4', 'DEMO49', 'DEMO12', 'DEMO'];
    final List<String> uplines = ['DEMO', 'DEMO49', 'DEMO12'];
    final List<String> exchanges = ['MCX', 'NSE', 'CE/PE'];
    final List<String> symbols = ['GOLD05DEC', 'SILVER05DEC', 'CRUDE05DEC'];
    final List<String> buySellTypes = [
      'SELL - SL Market',
      'BUY - SL Add Trade',
      'SELL - SL Add Trade',
      'BUY - SL Exit Market',
      'SELL - L Close Position',
      'BUY - SL Close Position',
      'SELL - SL Close Position',
      'BUY - L Close Position',
      'SELL - L Market',
      'BUY - L Market',
      'SELL - L Add Trade',
      'BUY - L Add Trade',
      'SELL - L Exit Market',
      'BUY - L Exit Market',
    ];

    final List<PendingOrder> orders = [];
    final now = DateTime.now();

    for (int i = 0; i < 50; i++) {
      final buySell = buySellTypes[i % buySellTypes.length];
      final qty = buySell.startsWith('BUY') ? [100.0, 1000000.0, 100000.0][i % 3] : -500.0;

      orders.add(PendingOrder(
        id: 'order_$i',
        userId: users[i % users.length],
        upline: uplines[i % uplines.length],
        exchange: exchanges[i % exchanges.length],
        symbol: symbols[i % symbols.length],
        buySell: buySell,
        qty: qty,
        lot: 1.00,
        triggerPrice: buySell.startsWith('SELL') ? -256 : 124191.00,
        orderDateTime: DateTime(2025, 11, 22, 3, 6, 34),
        modifyOrderDateTime: DateTime(2025, 11, 4, 1, 25, 35),
        orderType: 'Market',
        cmp: 36200.00,
        rPrice: 36200.00,
        deviceId: 'E621E1F8-C36C-495A-93FC-0C247A3E6E5F',
        ipAddress: '192.0.2.1',
      ));
    }

    return orders;
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../domain/usecases/pending_order/export_orders.dart';
import '../../../domain/usecases/pending_order/get_filter_data.dart';
import '../../../domain/usecases/pending_order/get_pending_orders.dart';
import 'pending_orders_event.dart';
import 'pending_orders_state.dart';

class PendingOrdersBloc extends Bloc<PendingOrdersEvent, PendingOrdersState> {
  final GetPendingOrders getPendingOrders;
  final GetPendingOrdersWithFilters getPendingOrdersWithFilters;
  final GetClients getClients;
  final GetExchanges getExchanges;
  final GetSymbols getSymbols;
  final GetOrderTypes getOrderTypes;
  final ExportToPdf exportToPdf;
  final ExportToExcel exportToExcel;
  PendingOrdersBloc({
    required this.getPendingOrders,
    required this.getPendingOrdersWithFilters,
    required this.getClients,
    required this.getExchanges,
    required this.getSymbols,
    required this.getOrderTypes,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const PendingOrdersInitial()) {
    on<LoadPendingOrdersEvent>(_onLoadPendingOrders);
    on<FilterByClientEvent>(_onFilterByClient);
    on<FilterByExchangeEvent>(_onFilterByExchange);
    on<FilterBySymbolEvent>(_onFilterBySymbol);
    on<FilterByTypeEvent>(_onFilterByType);
    on<UpdateFiltersEvent>(_onUpdateFilters);
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
      dynamic ordersResult;
      if (event.isClient) {
        ordersResult = await getPendingOrders(NoParams());
      } else {
        ordersResult = await getPendingOrdersWithFilters(const FilterParams());
      }
      final results = await Future.wait([
        getClients(NoParams()),
        getExchanges(NoParams()),
        getSymbols(NoParams()),
      ]);
      final clientsResult = results[0];
      final exchangesResult = results[1];
      final symbolsResult = results[2];
      List<PendingOrder> orders = [];
      if (ordersResult != null) {
        if (ordersResult.isLeft()) {
          final failure = ordersResult.fold((l) => l, (r) => null);
          emit(PendingOrdersError(failure?.message ?? 'Failed to load orders'));
          return;
        }
        orders = ordersResult.fold(
          (l) => <PendingOrder>[],
          (r) => r as List<PendingOrder>,
        );
      }
      final clients = clientsResult.fold((l) => <String>[], (r) => r);
      final exchanges = exchangesResult.fold((l) => <String>[], (r) => r);
      final symbols = symbolsResult.fold((l) => <String>[], (r) => r);
      final types = getOrderTypes();
      emit(
        PendingOrdersLoaded(
          allOrders: orders,
          filteredOrders: orders,
          clients: clients,
          exchanges: exchanges,
          symbols: symbols,
          types: types,
          totalRecords: orders.length,
        ),
      );
    } catch (e) {
      emit(PendingOrdersError(e.toString()));
    }
  }

  Future<void> _onFilterByClient(
    FilterByClientEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final result = await getPendingOrdersWithFilters(
        FilterParams(
          client: event.client,
          exchange: currentState.selectedExchange,
          symbol: currentState.selectedSymbol,
          type: currentState.selectedType,
        ),
      );
      result.fold(
        (failure) => emit(PendingOrdersError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedClient: event.client,
            filteredOrders: filtered,
            totalRecords: filtered.length,
            clearClient: event.client == null || event.client!.isEmpty,
          ),
        ),
      );
    }
  }

  Future<void> _onFilterByExchange(
    FilterByExchangeEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final result = await getPendingOrdersWithFilters(
        FilterParams(
          client: currentState.selectedClient,
          exchange: event.exchange,
          symbol: currentState.selectedSymbol,
          type: currentState.selectedType,
        ),
      );
      result.fold(
        (failure) => emit(PendingOrdersError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedExchange: event.exchange,
            filteredOrders: filtered,
            totalRecords: filtered.length,
            clearExchange: event.exchange == null || event.exchange!.isEmpty,
          ),
        ),
      );
    }
  }

  Future<void> _onFilterBySymbol(
    FilterBySymbolEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final result = await getPendingOrdersWithFilters(
        FilterParams(
          client: currentState.selectedClient,
          exchange: currentState.selectedExchange,
          symbol: event.symbol,
          type: currentState.selectedType,
        ),
      );
      result.fold(
        (failure) => emit(PendingOrdersError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedSymbol: event.symbol,
            filteredOrders: filtered,
            totalRecords: filtered.length,
            clearSymbol: event.symbol == null || event.symbol!.isEmpty,
          ),
        ),
      );
    }
  }

  Future<void> _onFilterByType(
    FilterByTypeEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final result = await getPendingOrdersWithFilters(
        FilterParams(
          client: currentState.selectedClient,
          exchange: currentState.selectedExchange,
          symbol: currentState.selectedSymbol,
          type: event.type,
        ),
      );
      result.fold(
        (failure) => emit(PendingOrdersError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedType: event.type,
            filteredOrders: filtered,
            totalRecords: filtered.length,
            clearType:
                event.type == null ||
                event.type!.isEmpty ||
                event.type == 'All',
          ),
        ),
      );
    }
  }

  void _onUpdateFilters(
    UpdateFiltersEvent event,
    Emitter<PendingOrdersState> emit,
  ) {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      emit(
        currentState.copyWith(
          selectedClient: event.client,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
          selectedType: event.type,
          clearClient: event.client == null || event.client!.isEmpty,
          clearExchange: event.exchange == null || event.exchange!.isEmpty,
          clearSymbol: event.symbol == null || event.symbol!.isEmpty,
          clearType:
              event.type == null || event.type!.isEmpty || event.type == 'All',
        ),
      );
    }
  }

  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final result = await getPendingOrdersWithFilters(
        FilterParams(
          client: event.client,
          exchange: event.exchange,
          symbol: event.symbol,
          type: event.type,
        ),
      );
      result.fold(
        (failure) => emit(PendingOrdersError(failure.message)),
        (filtered) => emit(
          currentState.copyWith(
            selectedClient: event.client,
            selectedExchange: event.exchange,
            selectedSymbol: event.symbol,
            selectedType: event.type,
            filteredOrders: filtered,
            totalRecords: filtered.length,
          ),
        ),
      );
    }
  }

  Future<void> _onResetFilters(
    ResetFiltersEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      final result = await getPendingOrders(NoParams());
      result.fold(
        (failure) => emit(PendingOrdersError(failure.message)),
        (orders) => emit(
          PendingOrdersLoaded(
            allOrders: orders,
            filteredOrders: orders,
            clients: currentState.clients,
            exchanges: currentState.exchanges,
            symbols: currentState.symbols,
            types: currentState.types,
            totalRecords: orders.length,
          ),
        ),
      );
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
          case 'device':
            comparison = (a.device ?? '').compareTo(b.device ?? '');
            break;
          case 'city':
            comparison = (a.city ?? '').compareTo(b.city ?? '');
            break;
        }
        return event.ascending ? comparison : -comparison;
      });
      emit(
        currentState.copyWith(
          filteredOrders: sorted,
          sortColumn: event.columnId,
          sortAscending: event.ascending,
        ),
      );
    }
  }

  Future<void> _onExportToPdf(
    ExportToPdfEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      emit(const PendingOrdersExporting('pdf'));
      final result = await exportToPdf(
        ExportParams(orders: currentState.filteredOrders),
      );
      result.fold(
        (failure) {
          emit(PendingOrdersError(failure.message));
          emit(currentState);
        },
        (filePath) {
          emit(
            PendingOrdersExportSuccess(
              message: 'PDF exported successfully',
              filePath: filePath,
            ),
          );
          emit(currentState);
        },
      );
    }
  }

  Future<void> _onExportToExcel(
    ExportToExcelEvent event,
    Emitter<PendingOrdersState> emit,
  ) async {
    if (state is PendingOrdersLoaded) {
      final currentState = state as PendingOrdersLoaded;
      emit(const PendingOrdersExporting('excel'));
      final result = await exportToExcel(
        ExportParams(orders: currentState.filteredOrders),
      );
      result.fold(
        (failure) {
          emit(PendingOrdersError(failure.message));
          emit(currentState);
        },
        (filePath) {
          emit(
            PendingOrdersExportSuccess(
              message: 'Excel exported successfully',
              filePath: filePath,
            ),
          );
          emit(currentState);
        },
      );
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
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/deals.dart';
import '../../../domain/usecases/deals/deals_usecases.dart';
import 'deals_event.dart';
import 'deals_state.dart';

/// Deals BLoC
class DealsBloc extends Bloc<DealsEvent, DealsState> {
  final GetDeals getDeals;
  final GetDealsWithFilters getDealsWithFilters;
  final GetDealsClients getClients;
  final GetDealsExchanges getExchanges;
  final GetDealsSymbols getSymbols;
  final GetDealsOrderTypes getOrderTypes;
  final GetDealsStatuses getStatuses;
  final ExportDealsToPdf exportToPdf;
  final ExportDealsToExcel exportToExcel;

  DealsBloc({
    required this.getDeals,
    required this.getDealsWithFilters,
    required this.getClients,
    required this.getExchanges,
    required this.getSymbols,
    required this.getOrderTypes,
    required this.getStatuses,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const DealsInitial()) {
    on<LoadDealsEvent>(_onLoadDeals);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ResetFiltersEvent>(_onResetFilters);
    on<SelectDealEvent>(_onSelectDeal);
    on<SortDealsByColumnEvent>(_onSortByColumn);
    on<ExportDealsToPdfEvent>(_onExportToPdf);
    on<ExportDealsToExcelEvent>(_onExportToExcel);
  }

  Future<void> _onLoadDeals(
      LoadDealsEvent event,
      Emitter<DealsState> emit,
      ) async {
    emit(const DealsLoading());

    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        getDeals(NoParams()),
        getClients(NoParams()),
        getExchanges(NoParams()),
        getSymbols(NoParams()),
        getOrderTypes(NoParams()),
        getStatuses(NoParams()),
      ]);

      final dealsResult = results[0];
      final clientsResult = results[1];
      final exchangesResult = results[2];
      final symbolsResult = results[3];
      final orderTypesResult = results[4];
      final statusesResult = results[5];

      // Check for failures
      if (dealsResult.isLeft()) {
        final failure = dealsResult.fold((l) => l, (r) => null);
        emit(DealsError(failure?.message ?? 'Failed to load deals'));
        return;
      }

      final deals = dealsResult.fold((l) => <Deal>[], (r) => r as List<Deal>);
      final clients = clientsResult.fold((l) => <String>[], (r) => r as List<String>);
      final exchanges = exchangesResult.fold((l) => <String>[], (r) => r as List<String>);
      final symbols = symbolsResult.fold((l) => <String>[], (r) => r as List<String>);
      final orderTypes = orderTypesResult.fold((l) => <String>[], (r) => r as List<String>);
      final statuses = statusesResult.fold((l) => <String>[], (r) => r as List<String>);

      emit(DealsLoaded(
        deals: deals,
        filteredDeals: deals,
        totalRecords: deals.length,
        clients: clients,
        exchanges: exchanges,
        symbols: symbols,
        orderTypes: orderTypes,
        statuses: statuses,
      ));
    } catch (e) {
      emit(DealsError(e.toString()));
    }
  }

  Future<void> _onApplyFilters(
      ApplyFiltersEvent event,
      Emitter<DealsState> emit,
      ) async {
    if (state is! DealsLoaded) return;

    final currentState = state as DealsLoaded;
    emit(const DealsLoading());

    final result = await getDealsWithFilters(DealsFilterParams(
      startDate: event.startDate,
      endDate: event.endDate,
      client: event.client,
      exchange: event.exchange,
      symbol: event.symbol,
      orderType: event.orderType,
      status: event.status,
    ));

    result.fold(
          (failure) => emit(DealsError(failure.message)),
          (deals) => emit(currentState.copyWith(
        filteredDeals: deals,
        totalRecords: deals.length,
        startDate: event.startDate,
        endDate: event.endDate,
        selectedClient: event.client,
        selectedExchange: event.exchange,
        selectedSymbol: event.symbol,
        selectedOrderType: event.orderType,
        selectedStatus: event.status,
      )),
    );
  }

  Future<void> _onResetFilters(
      ResetFiltersEvent event,
      Emitter<DealsState> emit,
      ) async {
    if (state is! DealsLoaded) return;

    final currentState = state as DealsLoaded;

    emit(DealsLoaded(
      deals: currentState.deals,
      filteredDeals: currentState.deals,
      totalRecords: currentState.deals.length,
      clients: currentState.clients,
      exchanges: currentState.exchanges,
      symbols: currentState.symbols,
      orderTypes: currentState.orderTypes,
      statuses: currentState.statuses,
    ));
  }

  void _onSelectDeal(
      SelectDealEvent event,
      Emitter<DealsState> emit,
      ) {
    if (state is! DealsLoaded) return;

    final currentState = state as DealsLoaded;
    emit(currentState.copyWith(selectedDealId: event.dealId));
  }

  void _onSortByColumn(
      SortDealsByColumnEvent event,
      Emitter<DealsState> emit,
      ) {
    if (state is! DealsLoaded) return;

    final currentState = state as DealsLoaded;
    final sortedDeals = List<Deal>.from(currentState.filteredDeals);

    sortedDeals.sort((a, b) {
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
        case 'orderDuration':
          comparison = a.orderDuration.compareTo(b.orderDuration);
          break;
        case 'status':
          comparison = a.status.compareTo(b.status);
          break;
        default:
          comparison = 0;
      }
      return event.ascending ? comparison : -comparison;
    });

    emit(currentState.copyWith(
      filteredDeals: sortedDeals,
      sortColumn: event.columnId,
      sortAscending: event.ascending,
    ));
  }

  Future<void> _onExportToPdf(
      ExportDealsToPdfEvent event,
      Emitter<DealsState> emit,
      ) async {
    if (state is! DealsLoaded) return;

    final currentState = state as DealsLoaded;

    final result = await exportToPdf(currentState.filteredDeals);

    result.fold(
          (failure) => emit(DealsError(failure.message)),
          (path) {
        emit(DealsExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ));
        // Restore previous state
        emit(currentState);
      },
    );
  }

  Future<void> _onExportToExcel(
      ExportDealsToExcelEvent event,
      Emitter<DealsState> emit,
      ) async {
    if (state is! DealsLoaded) return;

    final currentState = state as DealsLoaded;

    final result = await exportToExcel(currentState.filteredDeals);

    result.fold(
          (failure) => emit(DealsError(failure.message)),
          (path) {
        emit(DealsExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ));
        // Restore previous state
        emit(currentState);
      },
    );
  }
}
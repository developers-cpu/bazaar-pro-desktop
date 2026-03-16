import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/deleted_trade/deleted_trade.dart';
import '../../../domain/usecases/deleted_trade/deleted_trade_usecases.dart';
import 'deleted_trade_event.dart';
import 'deleted_trade_state.dart';
class DeletedTradeBloc extends Bloc<DeletedTradeEvent, DeletedTradeState> {
  final GetDeletedTrades getDeletedTrades;
  final GetDeletedTradesWithFilters getDeletedTradesWithFilters;
  final GetDeletedTradeUserTypes getUserTypes;
  final GetDeletedTradeUsers getUsers;
  final GetDeletedTradeExchanges getExchanges;
  final GetDeletedTradeSymbols getSymbols;
  final ExportDeletedTradesToPdf exportToPdf;
  final ExportDeletedTradesToExcel exportToExcel;
  DeletedTradeBloc({
    required this.getDeletedTrades,
    required this.getDeletedTradesWithFilters,
    required this.getUserTypes,
    required this.getUsers,
    required this.getExchanges,
    required this.getSymbols,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const DeletedTradeInitial()) {
    on<LoadDeletedTradesEvent>(_onLoadDeletedTrades);
    on<ApplyDeletedTradeFiltersEvent>(_onApplyFilters);
    on<ResetDeletedTradeFiltersEvent>(_onResetFilters);
    on<SortDeletedTradesByColumnEvent>(_onSortByColumn);
    on<ExportDeletedTradesToPdfEvent>(_onExportToPdf);
    on<ExportDeletedTradesToExcelEvent>(_onExportToExcel);
  }
  Future<void> _onLoadDeletedTrades(
    LoadDeletedTradesEvent event,
    Emitter<DeletedTradeState> emit,
  ) async {
    emit(const DeletedTradeLoading());
    try {
      final results = await Future.wait([
        getDeletedTrades(NoParams()),
        getUserTypes(NoParams()),
        getUsers(NoParams()),
        getExchanges(NoParams()),
        getSymbols(NoParams()),
      ]);
      final tradesResult = results[0];
      final userTypesResult = results[1];
      final usersResult = results[2];
      final exchangesResult = results[3];
      final symbolsResult = results[4];
      if (tradesResult.isLeft()) {
        final failure = tradesResult.fold((l) => l, (r) => null);
        emit(DeletedTradeError(failure?.message ?? 'Failed to load trades'));
        return;
      }
      final trades = tradesResult.fold(
        (l) => <DeletedTrade>[],
        (r) => r as List<DeletedTrade>,
      );
      final userTypesList = userTypesResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      final usersList = usersResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      final exchangesList = exchangesResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      final symbolsList = symbolsResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      emit(
        DeletedTradeLoaded(
          trades: trades,
          filteredTrades: trades,
          totalRecords: trades.length,
          userTypes: userTypesList,
          users: usersList,
          exchanges: exchangesList,
          symbols: symbolsList,
        ),
      );
    } catch (e) {
      emit(DeletedTradeError(e.toString()));
    }
  }
  Future<void> _onApplyFilters(
    ApplyDeletedTradeFiltersEvent event,
    Emitter<DeletedTradeState> emit,
  ) async {
    if (state is! DeletedTradeLoaded) return;
    final currentState = state as DeletedTradeLoaded;
    emit(const DeletedTradeLoading());
    final result = await getDeletedTradesWithFilters(
      DeletedTradeFilterParams(
        userType: event.userType,
        user: event.user,
        exchange: event.exchange,
        symbol: event.symbol,
      ),
    );
    result.fold(
      (failure) => emit(DeletedTradeError(failure.message)),
      (trades) => emit(
        currentState.copyWith(
          filteredTrades: trades,
          totalRecords: trades.length,
          selectedUserType: event.userType,
          selectedUser: event.user,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
        ),
      ),
    );
  }
  Future<void> _onResetFilters(
    ResetDeletedTradeFiltersEvent event,
    Emitter<DeletedTradeState> emit,
  ) async {
    if (state is! DeletedTradeLoaded) return;
    final currentState = state as DeletedTradeLoaded;
    emit(
      DeletedTradeLoaded(
        trades: currentState.trades,
        filteredTrades: currentState.trades,
        totalRecords: currentState.trades.length,
        userTypes: currentState.userTypes,
        users: currentState.users,
        exchanges: currentState.exchanges,
        symbols: currentState.symbols,
      ),
    );
  }
  void _onSortByColumn(
    SortDeletedTradesByColumnEvent event,
    Emitter<DeletedTradeState> emit,
  ) {
    if (state is! DeletedTradeLoaded) return;
    final currentState = state as DeletedTradeLoaded;
    final sortedTrades = List<DeletedTrade>.from(currentState.filteredTrades);
    sortedTrades.sort((a, b) {
      int comparison = 0;
      switch (event.columnId) {
        case 'userName':
          comparison = a.userName.compareTo(b.userName);
          break;
        case 'parentUser':
          comparison = a.parentUser.compareTo(b.parentUser);
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
        case 'type':
          comparison = a.type.compareTo(b.type);
          break;
        case 'pl':
          comparison = a.pl.compareTo(b.pl);
          break;
        case 'tradePrice':
          comparison = a.tradePrice.compareTo(b.tradePrice);
          break;
        case 'brokerage':
          comparison = a.brokerage.compareTo(b.brokerage);
          break;
        case 'ratePrice':
          comparison = a.ratePrice.compareTo(b.ratePrice);
          break;
        case 'executionDateTime':
          comparison = a.executionDateTime.compareTo(b.executionDateTime);
          break;
        case 'deviceId':
          comparison = a.deviceId.compareTo(b.deviceId);
          break;
        case 'city':
          comparison = a.city.compareTo(b.city);
          break;
        case 'device':
          comparison = a.device.compareTo(b.device);
          break;
        case 'ipAddress':
          comparison = a.ipAddress.compareTo(b.ipAddress);
          break;
        default:
          comparison = 0;
      }
      return event.ascending ? comparison : -comparison;
    });
    emit(
      currentState.copyWith(
        filteredTrades: sortedTrades,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ),
    );
  }
  Future<void> _onExportToPdf(
    ExportDeletedTradesToPdfEvent event,
    Emitter<DeletedTradeState> emit,
  ) async {
    if (state is! DeletedTradeLoaded) return;
    final currentState = state as DeletedTradeLoaded;
    final result = await exportToPdf(currentState.filteredTrades);
    result.fold((failure) => emit(DeletedTradeError(failure.message)), (path) {
      emit(
        DeletedTradeExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
  Future<void> _onExportToExcel(
    ExportDeletedTradesToExcelEvent event,
    Emitter<DeletedTradeState> emit,
  ) async {
    if (state is! DeletedTradeLoaded) return;
    final currentState = state as DeletedTradeLoaded;
    final result = await exportToExcel(currentState.filteredTrades);
    result.fold((failure) => emit(DeletedTradeError(failure.message)), (path) {
      emit(
        DeletedTradeExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
}

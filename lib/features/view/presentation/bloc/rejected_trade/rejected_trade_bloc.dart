import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/rejected_trade/rejected_trade.dart';
import '../../../domain/usecases/rejected_trade/rejected_trade_usecases.dart';
import 'rejected_trade_event.dart';
import 'rejected_trade_state.dart';

class RejectedTradeBloc extends Bloc<RejectedTradeEvent, RejectedTradeState> {
  final GetRejectedTrades getRejectedTrades;
  final GetRejectedTradesWithFilters getRejectedTradesWithFilters;
  final GetRejectedTradeUserTypes getUserTypes;
  final GetRejectedTradeUsers getUsers;
  final GetRejectedTradeExchanges getExchanges;
  final GetRejectedTradeSymbols getSymbols;
  final ExportRejectedTradesToPdf exportToPdf;
  final ExportRejectedTradesToExcel exportToExcel;
  RejectedTradeBloc({
    required this.getRejectedTrades,
    required this.getRejectedTradesWithFilters,
    required this.getUserTypes,
    required this.getUsers,
    required this.getExchanges,
    required this.getSymbols,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const RejectedTradeInitial()) {
    on<LoadRejectedTradesEvent>(_onLoadRejectedTrades);
    on<ApplyRejectedTradeFiltersEvent>(_onApplyFilters);
    on<ResetRejectedTradeFiltersEvent>(_onResetFilters);
    on<SortRejectedTradesByColumnEvent>(_onSortByColumn);
    on<ExportRejectedTradesToPdfEvent>(_onExportToPdf);
    on<ExportRejectedTradesToExcelEvent>(_onExportToExcel);
  }
  Future<void> _onLoadRejectedTrades(
    LoadRejectedTradesEvent event,
    Emitter<RejectedTradeState> emit,
  ) async {
    emit(const RejectedTradeLoading());
    try {
      final results = await Future.wait([
        getRejectedTrades(NoParams()),
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
        emit(RejectedTradeError(failure?.message ?? 'Failed to load trades'));
        return;
      }
      final trades = tradesResult.fold(
        (l) => <RejectedTrade>[],
        (r) => r as List<RejectedTrade>,
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
        RejectedTradeLoaded(
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
      emit(RejectedTradeError(e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyRejectedTradeFiltersEvent event,
    Emitter<RejectedTradeState> emit,
  ) async {
    if (state is! RejectedTradeLoaded) return;
    final currentState = state as RejectedTradeLoaded;
    emit(const RejectedTradeLoading());
    final result = await getRejectedTradesWithFilters(
      RejectedTradeFilterParams(
        userType: event.userType,
        user: event.user,
        exchange: event.exchange,
        symbol: event.symbol,
      ),
    );
    result.fold(
      (failure) => emit(RejectedTradeError(failure.message)),
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
    ResetRejectedTradeFiltersEvent event,
    Emitter<RejectedTradeState> emit,
  ) async {
    if (state is! RejectedTradeLoaded) return;
    final currentState = state as RejectedTradeLoaded;
    emit(
      RejectedTradeLoaded(
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
    SortRejectedTradesByColumnEvent event,
    Emitter<RejectedTradeState> emit,
  ) {
    if (state is! RejectedTradeLoaded) return;
    final currentState = state as RejectedTradeLoaded;
    final sortedTrades = List<RejectedTrade>.from(currentState.filteredTrades);
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
    ExportRejectedTradesToPdfEvent event,
    Emitter<RejectedTradeState> emit,
  ) async {
    if (state is! RejectedTradeLoaded) return;
    final currentState = state as RejectedTradeLoaded;
    final result = await exportToPdf(currentState.filteredTrades);
    result.fold((failure) => emit(RejectedTradeError(failure.message)), (path) {
      emit(
        RejectedTradeExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }

  Future<void> _onExportToExcel(
    ExportRejectedTradesToExcelEvent event,
    Emitter<RejectedTradeState> emit,
  ) async {
    if (state is! RejectedTradeLoaded) return;
    final currentState = state as RejectedTradeLoaded;
    final result = await exportToExcel(currentState.filteredTrades);
    result.fold((failure) => emit(RejectedTradeError(failure.message)), (path) {
      emit(
        RejectedTradeExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
}

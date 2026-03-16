import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/rejection_log/rejection_log.dart';
import '../../../domain/usecases/ rejection_log/rejection_log_usecases.dart';
import 'rejection_log_event.dart';
import 'rejection_log_state.dart';
class RejectionLogBloc extends Bloc<RejectionLogEvent, RejectionLogState> {
  final GetRejectionLogs getRejectionLogs;
  final GetRejectionLogsWithFilters getRejectionLogsWithFilters;
  final GetRejectionLogClients getClients;
  final GetRejectionLogExchanges getExchanges;
  final GetRejectionLogSymbols getSymbols;
  final ExportRejectionLogsToPdf exportToPdf;
  final ExportRejectionLogsToExcel exportToExcel;
  RejectionLogBloc({
    required this.getRejectionLogs,
    required this.getRejectionLogsWithFilters,
    required this.getClients,
    required this.getExchanges,
    required this.getSymbols,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const RejectionLogInitial()) {
    on<LoadRejectionLogsEvent>(_onLoadRejectionLogs);
    on<ApplyRejectionLogFiltersEvent>(_onApplyFilters);
    on<UpdateRejectionLogFiltersEvent>(_onUpdateFilters);
    on<ResetRejectionLogFiltersEvent>(_onResetFilters);
    on<SortRejectionLogsByColumnEvent>(_onSortByColumn);
    on<ExportRejectionLogsToPdfEvent>(_onExportToPdf);
    on<ExportRejectionLogsToExcelEvent>(_onExportToExcel);
  }
  Future<void> _onLoadRejectionLogs(
    LoadRejectionLogsEvent event,
    Emitter<RejectionLogState> emit,
  ) async {
    emit(const RejectionLogLoading());
    try {
      final results = await Future.wait([
        getRejectionLogs(NoParams()),
        getClients(NoParams()),
        getSymbols(NoParams()),
      ]);
      final logsResult = results[0];
      final clientsResult = results[1];
      final symbolsResult = results[2];
      if (logsResult.isLeft()) {
        final failure = logsResult.fold((l) => l, (r) => null);
        emit(RejectionLogError(failure?.message ?? 'Failed to load logs'));
        return;
      }
      final logs = logsResult.fold(
        (l) => <RejectionLog>[],
        (r) => r as List<RejectionLog>,
      );
      final clients = clientsResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      final exchanges = <String>[
        'NSE',
        'MCX',
        'CE/PE',
        'OTHERS',
        'COMEX FUTURE',
        'COMEX SPOT',
        'CRYPTO',
        'GIFT',
        'FOREX',
      ];
      final symbols = symbolsResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      emit(
        RejectionLogLoaded(
          logs: logs,
          filteredLogs: logs,
          totalRecords: logs.length,
          clients: clients,
          exchanges: exchanges,
          symbols: symbols,
        ),
      );
    } catch (e) {
      emit(RejectionLogError(e.toString()));
    }
  }
  Future<void> _onApplyFilters(
    ApplyRejectionLogFiltersEvent event,
    Emitter<RejectionLogState> emit,
  ) async {
    if (state is! RejectionLogLoaded) return;
    final currentState = state as RejectionLogLoaded;
    emit(const RejectionLogLoading());
    final result = await getRejectionLogsWithFilters(
      RejectionLogFilterParams(
        startDate: event.startDate,
        endDate: event.endDate,
        client: event.client,
        exchange: event.exchange,
        symbol: event.symbol,
      ),
    );
    result.fold(
      (failure) => emit(RejectionLogError(failure.message)),
      (logs) => emit(
        currentState.copyWith(
          filteredLogs: logs,
          totalRecords: logs.length,
          startDate: event.startDate,
          endDate: event.endDate,
          selectedClient: event.client,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
        ),
      ),
    );
  }
  void _onUpdateFilters(
    UpdateRejectionLogFiltersEvent event,
    Emitter<RejectionLogState> emit,
  ) {
    if (state is! RejectionLogLoaded) return;
    final currentState = state as RejectionLogLoaded;
    emit(
      currentState.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
        selectedClient: event.client,
        selectedExchange: event.exchange,
        selectedSymbol: event.symbol,
      ),
    );
  }
  Future<void> _onResetFilters(
    ResetRejectionLogFiltersEvent event,
    Emitter<RejectionLogState> emit,
  ) async {
    if (state is! RejectionLogLoaded) return;
    final currentState = state as RejectionLogLoaded;
    emit(
      RejectionLogLoaded(
        logs: currentState.logs,
        filteredLogs: currentState.logs,
        totalRecords: currentState.logs.length,
        clients: currentState.clients,
        exchanges: currentState.exchanges,
        symbols: currentState.symbols,
      ),
    );
  }
  void _onSortByColumn(
    SortRejectionLogsByColumnEvent event,
    Emitter<RejectionLogState> emit,
  ) {
    if (state is! RejectionLogLoaded) return;
    final currentState = state as RejectionLogLoaded;
    final sortedLogs = List<RejectionLog>.from(currentState.filteredLogs);
    sortedLogs.sort((a, b) {
      int comparison = 0;
      switch (event.columnId) {
        case 'orderDateTime':
          comparison = a.orderDateTime.compareTo(b.orderDateTime);
          break;
        case 'userName':
          comparison = a.userName.compareTo(b.userName);
          break;
        case 'symbol':
          comparison = a.symbol.compareTo(b.symbol);
          break;
        case 'type':
          comparison = a.type.compareTo(b.type);
          break;
        case 'qty':
          comparison = a.qty.compareTo(b.qty);
          break;
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
        case 'comment':
          comparison = a.comment.compareTo(b.comment);
          break;
        case 'status':
          comparison = a.status.compareTo(b.status);
          break;
        case 'deviceId':
          comparison = a.deviceId.compareTo(b.deviceId);
          break;
        case 'device':
          comparison = a.device.compareTo(b.device);
          break;
        case 'city':
          comparison = a.city.compareTo(b.city);
          break;
        case 'ipAddress':
          comparison = a.ipAddress.compareTo(b.ipAddress);
          break;
        case 'date':
          comparison = a.date.compareTo(b.date);
          break;
        default:
          comparison = 0;
      }
      return event.ascending ? comparison : -comparison;
    });
    emit(
      currentState.copyWith(
        filteredLogs: sortedLogs,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ),
    );
  }
  Future<void> _onExportToPdf(
    ExportRejectionLogsToPdfEvent event,
    Emitter<RejectionLogState> emit,
  ) async {
    if (state is! RejectionLogLoaded) return;
    final currentState = state as RejectionLogLoaded;
    final result = await exportToPdf(currentState.filteredLogs);
    result.fold((failure) => emit(RejectionLogError(failure.message)), (path) {
      emit(
        RejectionLogExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
  Future<void> _onExportToExcel(
    ExportRejectionLogsToExcelEvent event,
    Emitter<RejectionLogState> emit,
  ) async {
    if (state is! RejectionLogLoaded) return;
    final currentState = state as RejectionLogLoaded;
    final result = await exportToExcel(currentState.filteredLogs);
    result.fold((failure) => emit(RejectionLogError(failure.message)), (path) {
      emit(
        RejectionLogExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
}

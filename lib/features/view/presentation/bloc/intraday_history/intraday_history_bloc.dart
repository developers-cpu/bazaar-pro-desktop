import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/intraday_history/intraday_history.dart';
import '../../../domain/usecases/intraday_history/intraday_history_usecases.dart';
import 'intraday_history_event.dart';
import 'intraday_history_state.dart';

class IntradayHistoryBloc
    extends Bloc<IntradayHistoryEvent, IntradayHistoryState> {
  final GetIntradayHistory getIntradayHistory;
  final GetIntradayHistoryInSeconds getIntradayHistoryInSeconds;
  final GetIntradayExchanges getExchanges;
  final GetIntradaySymbols getSymbols;
  final GetIntradayTimings getTimings;
  final ExportIntradayToPdf exportToPdf;
  final ExportIntradayToExcel exportToExcel;

  IntradayHistoryBloc({
    required this.getIntradayHistory,
    required this.getIntradayHistoryInSeconds,
    required this.getExchanges,
    required this.getSymbols,
    required this.getTimings,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const IntradayHistoryInitial()) {
    on<LoadIntradayHistoryEvent>(_onLoadIntradayHistory);
    on<ApplyIntradayFiltersEvent>(_onApplyFilters);
    on<ResetIntradayFiltersEvent>(_onResetFilters);
    on<NavigateToSecondsViewEvent>(_onNavigateToSecondsView);
    on<LoadSecondsDataEvent>(_onLoadSecondsData);
    on<BackToListViewEvent>(_onBackToListView);
    on<SortIntradayByColumnEvent>(_onSortByColumn);
    on<ExportIntradayToPdfEvent>(_onExportToPdf);
    on<ExportIntradayToExcelEvent>(_onExportToExcel);
  }

  Future<void> _onLoadIntradayHistory(
      LoadIntradayHistoryEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    emit(const IntradayHistoryLoading());

    try {
      final results = await Future.wait([
        getIntradayHistory(const IntradayHistoryParams()),
        getExchanges(NoParams()),
        getSymbols(NoParams()),
        getTimings(NoParams()),
      ]);

      final historyResult = results[0];
      final exchangesResult = results[1];
      final symbolsResult = results[2];
      final timingsResult = results[3];

      if (historyResult.isLeft()) {
        final failure = historyResult.fold((l) => l, (r) => null);
        emit(IntradayHistoryError(
            failure?.message ?? 'Failed to load intraday history'));
        return;
      }

      final history = historyResult.fold(
              (l) => <IntradayHistory>[], (r) => r as List<IntradayHistory>);
      final exchanges =
      exchangesResult.fold((l) => <String>[], (r) => r as List<String>);
      final symbols =
      symbolsResult.fold((l) => <String>[], (r) => r as List<String>);
      final timings =
      timingsResult.fold((l) => <String>[], (r) => r as List<String>);

      emit(IntradayHistoryLoaded(
        history: history,
        totalRecords: history.length,
        exchanges: exchanges,
        symbols: symbols,
        timings: timings,
      ));
    } catch (e) {
      emit(IntradayHistoryError(e.toString()));
    }
  }

  Future<void> _onApplyFilters(
      ApplyIntradayFiltersEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    if (state is! IntradayHistoryLoaded) return;

    final currentState = state as IntradayHistoryLoaded;
    emit(const IntradayHistoryLoading());

    final result = await getIntradayHistory(IntradayHistoryParams(
      date: event.date,
      exchange: event.exchange,
      symbol: event.symbol,
      timing: event.timing,
    ));

    result.fold(
          (failure) => emit(IntradayHistoryError(failure.message)),
          (history) => emit(currentState.copyWith(
        history: history,
        totalRecords: history.length,
        selectedDate: event.date,
        selectedExchange: event.exchange,
        selectedSymbol: event.symbol,
        selectedTiming: event.timing,
      )),
    );
  }

  Future<void> _onResetFilters(
      ResetIntradayFiltersEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    if (state is! IntradayHistoryLoaded) return;

    final currentState = state as IntradayHistoryLoaded;
    final result = await getIntradayHistory(const IntradayHistoryParams());

    result.fold(
          (failure) => emit(IntradayHistoryError(failure.message)),
          (history) => emit(IntradayHistoryLoaded(
        history: history,
        totalRecords: history.length,
        exchanges: currentState.exchanges,
        symbols: currentState.symbols,
        timings: currentState.timings,
      )),
    );
  }

  Future<void> _onNavigateToSecondsView(
      NavigateToSecondsViewEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    // Simply transition to seconds view without loading data yet
    // User will select exchange and symbol, then click View
    emit(IntradayHistorySecondsView(
      history: const [],
      totalRecords: 0,
      date: event.date,
      exchange: event.exchange,
      symbol: event.symbol,
      startTime: event.startTime,
      endTime: event.endTime,
    ));
  }

  Future<void> _onLoadSecondsData(
      LoadSecondsDataEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    emit(const IntradayHistoryLoading());

    final result = await getIntradayHistoryInSeconds(
      IntradayHistorySecondsParams(
        date: event.date,
        exchange: event.exchange,
        symbol: event.symbol,
        startTime: event.startTime,
        endTime: event.endTime,
      ),
    );

    result.fold(
          (failure) => emit(IntradayHistoryError(failure.message)),
          (history) => emit(IntradayHistorySecondsView(
        history: history,
        totalRecords: history.length,
        date: event.date,
        exchange: event.exchange,
        symbol: event.symbol,
        startTime: event.startTime,
        endTime: event.endTime,
      )),
    );
  }

  Future<void> _onBackToListView(
      BackToListViewEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    add(const LoadIntradayHistoryEvent());
  }

  void _onSortByColumn(
      SortIntradayByColumnEvent event,
      Emitter<IntradayHistoryState> emit,
      ) {
    if (state is IntradayHistoryLoaded) {
      final currentState = state as IntradayHistoryLoaded;
      final sortedHistory = List<IntradayHistory>.from(currentState.history);

      sortedHistory.sort((a, b) {
        int comparison = 0;

        switch (event.columnId) {
          case 'timestamp':
            comparison = a.timestamp.compareTo(b.timestamp);
            break;
          case 'open':
            comparison = a.open.compareTo(b.open);
            break;
          case 'high':
            comparison = a.high.compareTo(b.high);
            break;
          case 'low':
            comparison = a.low.compareTo(b.low);
            break;
          case 'close':
            comparison = a.close.compareTo(b.close);
            break;
          case 'volume':
            comparison = a.volume.compareTo(b.volume);
            break;
          default:
            comparison = 0;
        }

        return event.ascending ? comparison : -comparison;
      });

      emit(currentState.copyWith(
        history: sortedHistory,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ));
    } else if (state is IntradayHistorySecondsView) {
      final currentState = state as IntradayHistorySecondsView;
      final sortedHistory = List<IntradayHistory>.from(currentState.history);

      sortedHistory.sort((a, b) {
        int comparison = 0;

        switch (event.columnId) {
          case 'timestamp':
            comparison = a.timestamp.compareTo(b.timestamp);
            break;
          case 'open':
            comparison = a.open.compareTo(b.open);
            break;
          case 'high':
            comparison = a.high.compareTo(b.high);
            break;
          case 'low':
            comparison = a.low.compareTo(b.low);
            break;
          case 'close':
            comparison = a.close.compareTo(b.close);
            break;
          case 'volume':
            comparison = a.volume.compareTo(b.volume);
            break;
          default:
            comparison = 0;
        }

        return event.ascending ? comparison : -comparison;
      });

      emit(currentState.copyWith(
        history: sortedHistory,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ));
    }
  }

  Future<void> _onExportToPdf(
      ExportIntradayToPdfEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    List<IntradayHistory> historyToExport = [];

    if (state is IntradayHistoryLoaded) {
      historyToExport = (state as IntradayHistoryLoaded).history;
    } else if (state is IntradayHistorySecondsView) {
      historyToExport = (state as IntradayHistorySecondsView).history;
    } else {
      return;
    }

    final currentState = state;
    final result = await exportToPdf(historyToExport);

    result.fold(
          (failure) => emit(IntradayHistoryError(failure.message)),
          (path) {
        emit(IntradayHistoryExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ));
        emit(currentState);
      },
    );
  }

  Future<void> _onExportToExcel(
      ExportIntradayToExcelEvent event,
      Emitter<IntradayHistoryState> emit,
      ) async {
    List<IntradayHistory> historyToExport = [];

    if (state is IntradayHistoryLoaded) {
      historyToExport = (state as IntradayHistoryLoaded).history;
    } else if (state is IntradayHistorySecondsView) {
      historyToExport = (state as IntradayHistorySecondsView).history;
    } else {
      return;
    }

    final currentState = state;
    final result = await exportToExcel(historyToExport);

    result.fold(
          (failure) => emit(IntradayHistoryError(failure.message)),
          (path) {
        emit(IntradayHistoryExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ));
        emit(currentState);
      },
    );
  }
}
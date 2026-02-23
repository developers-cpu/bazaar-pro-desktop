import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/script_master/script_master.dart';
import '../../../domain/usecases/script_master/script_master_usecases.dart';
import 'script_master_event.dart';
import 'script_master_state.dart';

class ScriptMasterBloc extends Bloc<ScriptMasterEvent, ScriptMasterState> {
  final GetScriptMasters getScriptMasters;
  final GetScriptMastersWithFilters getScriptMastersWithFilters;
  final GetScriptMasterExchanges getExchanges;
  final GetScriptMasterSymbols getSymbols;
  final ExportScriptMastersToPdf exportToPdf;
  final ExportScriptMastersToExcel exportToExcel;
  ScriptMasterBloc({
    required this.getScriptMasters,
    required this.getScriptMastersWithFilters,
    required this.getExchanges,
    required this.getSymbols,
    required this.exportToPdf,
    required this.exportToExcel,
  }) : super(const ScriptMasterInitial()) {
    on<LoadScriptMastersEvent>(_onLoadScriptMasters);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ResetFiltersEvent>(_onResetFilters);
    on<SelectScriptEvent>(_onSelectScript);
    on<SortScriptsByColumnEvent>(_onSortByColumn);
    on<ExportScriptMastersToPdfEvent>(_onExportToPdf);
    on<ExportScriptMastersToExcelEvent>(_onExportToExcel);
  }
  Future<void> _onLoadScriptMasters(
    LoadScriptMastersEvent event,
    Emitter<ScriptMasterState> emit,
  ) async {
    emit(const ScriptMasterLoading());
    try {
      final results = await Future.wait([
        getScriptMasters(NoParams()),
        getExchanges(NoParams()),
        getSymbols(NoParams()),
      ]);
      final scriptsResult = results[0];
      final exchangesResult = results[1];
      final symbolsResult = results[2];
      if (scriptsResult.isLeft()) {
        final failure = scriptsResult.fold((l) => l, (r) => null);
        emit(
          ScriptMasterError(
            failure?.message ?? 'Failed to load script masters',
          ),
        );
        return;
      }
      final scripts = scriptsResult.fold(
        (l) => <ScriptMaster>[],
        (r) => r as List<ScriptMaster>,
      );
      final exchanges = exchangesResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      final symbols = symbolsResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      );
      emit(
        ScriptMasterLoaded(
          scripts: scripts,
          filteredScripts: scripts,
          totalRecords: scripts.length,
          exchanges: exchanges,
          symbols: symbols,
        ),
      );
    } catch (e) {
      emit(ScriptMasterError(e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<ScriptMasterState> emit,
  ) async {
    if (state is! ScriptMasterLoaded) return;
    final currentState = state as ScriptMasterLoaded;
    emit(const ScriptMasterLoading());
    final result = await getScriptMastersWithFilters(
      ScriptMasterFilterParams(exchange: event.exchange, symbol: event.symbol),
    );
    result.fold(
      (failure) => emit(ScriptMasterError(failure.message)),
      (scripts) => emit(
        currentState.copyWith(
          filteredScripts: scripts,
          totalRecords: scripts.length,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
        ),
      ),
    );
  }

  Future<void> _onResetFilters(
    ResetFiltersEvent event,
    Emitter<ScriptMasterState> emit,
  ) async {
    if (state is! ScriptMasterLoaded) return;
    final currentState = state as ScriptMasterLoaded;
    emit(
      ScriptMasterLoaded(
        scripts: currentState.scripts,
        filteredScripts: currentState.scripts,
        totalRecords: currentState.scripts.length,
        exchanges: currentState.exchanges,
        symbols: currentState.symbols,
      ),
    );
  }

  void _onSelectScript(
    SelectScriptEvent event,
    Emitter<ScriptMasterState> emit,
  ) {
    if (state is! ScriptMasterLoaded) return;
    final currentState = state as ScriptMasterLoaded;
    emit(currentState.copyWith(selectedScriptId: event.scriptId));
  }

  void _onSortByColumn(
    SortScriptsByColumnEvent event,
    Emitter<ScriptMasterState> emit,
  ) {
    if (state is! ScriptMasterLoaded) return;
    final currentState = state as ScriptMasterLoaded;
    final sortedScripts = List<ScriptMaster>.from(currentState.filteredScripts);
    sortedScripts.sort((a, b) {
      int comparison = 0;
      switch (event.columnId) {
        case 'exchange':
          comparison = a.exchange.compareTo(b.exchange);
          break;
        case 'symbol':
          comparison = a.symbol.compareTo(b.symbol);
          break;
        case 'expiryDate':
          comparison = a.expiryDate.compareTo(b.expiryDate);
          break;
        case 'tradeAttribute':
          comparison = a.tradeAttribute.compareTo(b.tradeAttribute);
          break;
        case 'allowTrade':
          comparison = a.allowTrade.toString().compareTo(
            b.allowTrade.toString(),
          );
          break;
        default:
          comparison = 0;
      }
      return event.ascending ? comparison : -comparison;
    });
    emit(
      currentState.copyWith(
        filteredScripts: sortedScripts,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ),
    );
  }

  Future<void> _onExportToPdf(
    ExportScriptMastersToPdfEvent event,
    Emitter<ScriptMasterState> emit,
  ) async {
    if (state is! ScriptMasterLoaded) return;
    final currentState = state as ScriptMasterLoaded;
    final result = await exportToPdf(currentState.filteredScripts);
    result.fold((failure) => emit(ScriptMasterError(failure.message)), (path) {
      emit(
        ScriptMasterExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }

  Future<void> _onExportToExcel(
    ExportScriptMastersToExcelEvent event,
    Emitter<ScriptMasterState> emit,
  ) async {
    if (state is! ScriptMasterLoaded) return;
    final currentState = state as ScriptMasterLoaded;
    final result = await exportToExcel(currentState.filteredScripts);
    result.fold((failure) => emit(ScriptMasterError(failure.message)), (path) {
      emit(
        ScriptMasterExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }
}

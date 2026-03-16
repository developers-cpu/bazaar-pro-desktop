import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/script_quantity/script_quantity_usecases.dart';
import 'script_quantity_event.dart';
import 'script_quantity_state.dart';
class ScriptQuantityBloc
    extends Bloc<ScriptQuantityEvent, ScriptQuantityState> {
  final GetScriptQuantityExchanges getExchanges;
  final GetScriptQuantityGroups getGroups;
  final GetScriptQuantities getScriptQuantities;
  ScriptQuantityBloc({
    required this.getExchanges,
    required this.getGroups,
    required this.getScriptQuantities,
  }) : super(const ScriptQuantityInitial()) {
    on<LoadFiltersEvent>(_onLoadFilters);
    on<RestoreFiltersEvent>(_onRestoreFilters);
    on<UpdateScriptQuantityFilterEvent>(_onUpdateScriptQuantityFilter);
    on<LoadGroupsEvent>(_onLoadGroups);
    on<LoadScriptQuantitiesEvent>(_onLoadScriptQuantities);
    on<ResetFiltersEvent>(_onResetFilters);
  }
  Future<void> _onLoadFilters(
    LoadFiltersEvent event,
    Emitter<ScriptQuantityState> emit,
  ) async {
    emit(const ScriptQuantityLoading());
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
    emit(ScriptQuantityFiltersLoaded(exchanges: exchanges));
  }
  Future<void> _onRestoreFilters(
    RestoreFiltersEvent event,
    Emitter<ScriptQuantityState> emit,
  ) async {
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
    emit(
      ScriptQuantityFiltersLoaded(
        exchanges: exchanges,
        selectedExchange: event.exchange,
        selectedGroup: event.group,
      ),
    );
  }
  void _onUpdateScriptQuantityFilter(
    UpdateScriptQuantityFilterEvent event,
    Emitter<ScriptQuantityState> emit,
  ) {
    if (state is ScriptQuantityFiltersLoaded) {
      final currentState = state as ScriptQuantityFiltersLoaded;
      emit(currentState.copyWith(selectedExchange: event.exchange));
    }
  }
  Future<void> _onLoadGroups(
    LoadGroupsEvent event,
    Emitter<ScriptQuantityState> emit,
  ) async {
    if (state is! ScriptQuantityFiltersLoaded) return;
    final currentState = state as ScriptQuantityFiltersLoaded;
    emit(const ScriptQuantityLoading());
    final result = await getGroups(event.exchange);
    result.fold(
      (failure) => emit(ScriptQuantityError(failure.message)),
      (groups) => emit(
        currentState.copyWith(
          groups: groups,
          selectedExchange: event.exchange,
          selectedGroup: null,
        ),
      ),
    );
  }
  Future<void> _onLoadScriptQuantities(
    LoadScriptQuantitiesEvent event,
    Emitter<ScriptQuantityState> emit,
  ) async {
    emit(const ScriptQuantityLoading());
    final result = await getScriptQuantities(
      ScriptQuantityParams(exchange: event.exchange, group: event.group),
    );
    result.fold(
      (failure) => emit(ScriptQuantityError(failure.message)),
      (quantities) => emit(
        ScriptQuantityDataLoaded(
          quantities: quantities,
          exchange: event.exchange,
          group: event.group,
          totalRecords: quantities.length,
        ),
      ),
    );
  }
  Future<void> _onResetFilters(
    ResetFiltersEvent event,
    Emitter<ScriptQuantityState> emit,
  ) async {
    if (state is ScriptQuantityFiltersLoaded ||
        state is ScriptQuantityDataLoaded) {
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
      emit(ScriptQuantityFiltersLoaded(exchanges: exchanges));
    }
  }
}

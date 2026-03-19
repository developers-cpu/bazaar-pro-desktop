import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/net_postion/net_position.dart';
import '../../../domain/usecases/netposition/net_position_usecases.dart';
import 'net_position_event.dart';
import 'net_position_state.dart';

class NetPositionBloc extends Bloc<NetPositionEvent, NetPositionState> {
  final GetNetPositions getNetPositions;
  final GetNetPositionsWithFilters getNetPositionsWithFilters;
  final GetNetPositionClients getClients;
  final GetNetPositionExchanges getExchanges;
  final GetNetPositionSymbols getSymbols;
  final GetNetPositionUserTypes getUserTypes;
  final ExportNetPositionsToPdf exportToPdf;
  final ExportNetPositionsToExcel exportToExcel;
  final GetPositionDetails getPositionDetails;
  NetPositionBloc({
    required this.getNetPositions,
    required this.getNetPositionsWithFilters,
    required this.getClients,
    required this.getExchanges,
    required this.getSymbols,
    required this.getUserTypes,
    required this.exportToPdf,
    required this.exportToExcel,
    required this.getPositionDetails,
  }) : super(const NetPositionInitial()) {
    on<LoadNetPositionsEvent>(_onLoadNetPositions);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<UpdateFiltersEvent>(_onUpdateFilters);
    on<ResetFiltersEvent>(_onResetFilters);
    on<SelectPositionEvent>(_onSelectPosition);
    on<SortPositionsByColumnEvent>(_onSortByColumn);
    on<ExportNetPositionsToPdfEvent>(_onExportToPdf);
    on<ExportNetPositionsToExcelEvent>(_onExportToExcel);
    on<LoadPositionDetailsEvent>(_onLoadPositionDetails);
  }
  Future<void> _onLoadNetPositions(
    LoadNetPositionsEvent event,
    Emitter<NetPositionState> emit,
  ) async {
    emit(const NetPositionLoading());
    try {
      final results = await Future.wait([
        if (event.isClient) getNetPositions(NoParams()),
        getClients(NoParams()),
        getSymbols(NoParams()),
        getUserTypes(NoParams()),
      ]);
      var positions = <NetPosition>[];
      if (event.isClient) {
        final positionsResult = results[0];
        if (positionsResult.isLeft()) {
          final failure = positionsResult.fold((l) => l, (r) => null);
          emit(
            NetPositionError(
              failure?.message ?? 'Failed to load net positions',
            ),
          );
          return;
        }
        positions = positionsResult.fold(
          (l) => <NetPosition>[],
          (r) => r as List<NetPosition>,
        );
      }
      final startIndex = event.isClient ? 1 : 0;
      final clientsResult = results[startIndex];
      final symbolsResult = results[startIndex + 1];
      final userTypesResult = results[startIndex + 2];
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
      final userTypes = userTypesResult.fold(
        (l) => <String>[],
        (r) => r as List<String>,
      )..remove('All');
      emit(
        NetPositionLoaded(
          positions: positions,
          filteredPositions: positions,
          totalRecords: positions.length,
          clients: clients,
          exchanges: exchanges,
          symbols: symbols,
          userTypes: userTypes,
        ),
      );
    } catch (e) {
      emit(NetPositionError(e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<NetPositionState> emit,
  ) async {
    if (state is! NetPositionLoaded) return;
    final currentState = state as NetPositionLoaded;
    emit(const NetPositionLoading());
    final result = await getNetPositionsWithFilters(
      NetPositionFilterParams(
        userType: event.userType,
        client: event.client,
        exchange: event.exchange,
        symbol: event.symbol,
      ),
    );
    result.fold(
      (failure) => emit(NetPositionError(failure.message)),
      (positions) => emit(
        currentState.copyWith(
          filteredPositions: positions,
          totalRecords: positions.length,
          selectedUserType: event.userType,
          selectedClient: event.client,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
        ),
      ),
    );
  }

  void _onUpdateFilters(
    UpdateFiltersEvent event,
    Emitter<NetPositionState> emit,
  ) {
    if (state is! NetPositionLoaded) return;
    final currentState = state as NetPositionLoaded;
    emit(
      currentState.copyWith(
        selectedUserType: event.userType,
        selectedClient: event.client,
        selectedExchange: event.exchange,
        selectedSymbol: event.symbol,
      ),
    );
  }

  Future<void> _onResetFilters(
    ResetFiltersEvent event,
    Emitter<NetPositionState> emit,
  ) async {
    if (state is! NetPositionLoaded) return;
    final currentState = state as NetPositionLoaded;
    emit(
      NetPositionLoaded(
        positions: currentState.positions,
        filteredPositions: currentState.positions,
        totalRecords: currentState.positions.length,
        clients: currentState.clients,
        exchanges: currentState.exchanges,
        symbols: currentState.symbols,
        userTypes: currentState.userTypes,
      ),
    );
  }

  void _onSelectPosition(
    SelectPositionEvent event,
    Emitter<NetPositionState> emit,
  ) {
    if (state is! NetPositionLoaded) return;
    final currentState = state as NetPositionLoaded;
    emit(currentState.copyWith(selectedPositionId: event.positionId));
  }

  void _onSortByColumn(
    SortPositionsByColumnEvent event,
    Emitter<NetPositionState> emit,
  ) {
    if (state is! NetPositionLoaded) return;
    final currentState = state as NetPositionLoaded;
    final sortedPositions = List<NetPosition>.from(
      currentState.filteredPositions,
    );
    sortedPositions.sort((a, b) {
      int comparison = 0;
      switch (event.columnId) {
        case 'userName':
          comparison = a.userName.compareTo(b.userName);
          break;
        case 'exchange':
          comparison = a.exchange.compareTo(b.exchange);
          break;
        case 'symbol':
          comparison = a.symbol.compareTo(b.symbol);
          break;
        case 'buyQty':
          comparison = a.buyQty.compareTo(b.buyQty);
          break;
        case 'sellQty':
          comparison = a.sellQty.compareTo(b.sellQty);
          break;
        case 'netQty':
          comparison = a.netQty.compareTo(b.netQty);
          break;
        case 'netAvgPrice':
          comparison = a.netAvgPrice.compareTo(b.netAvgPrice);
          break;
        case 'cmp':
          comparison = a.cmp.compareTo(b.cmp);
          break;
        case 'm2mAmount':
          comparison = a.m2mAmount.compareTo(b.m2mAmount);
          break;
        case 'ourPercentage':
          comparison = a.ourPercentage.compareTo(b.ourPercentage);
          break;
        case 'userCount':
          comparison = a.userCount.compareTo(b.userCount);
          break;
        case 'days':
          comparison = a.days.compareTo(b.days);
          break;
        default:
          comparison = 0;
      }
      return event.ascending ? comparison : -comparison;
    });
    emit(
      currentState.copyWith(
        filteredPositions: sortedPositions,
        sortColumn: event.columnId,
        sortAscending: event.ascending,
      ),
    );
  }

  Future<void> _onExportToPdf(
    ExportNetPositionsToPdfEvent event,
    Emitter<NetPositionState> emit,
  ) async {
    if (state is! NetPositionLoaded) return;
    final currentState = state as NetPositionLoaded;
    final result = await exportToPdf(currentState.filteredPositions);
    result.fold((failure) => emit(NetPositionError(failure.message)), (path) {
      emit(
        NetPositionExportSuccess(
          message: 'PDF exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }

  Future<void> _onExportToExcel(
    ExportNetPositionsToExcelEvent event,
    Emitter<NetPositionState> emit,
  ) async {
    if (state is! NetPositionLoaded) return;
    final currentState = state as NetPositionLoaded;
    final result = await exportToExcel(currentState.filteredPositions);
    result.fold((failure) => emit(NetPositionError(failure.message)), (path) {
      emit(
        NetPositionExportSuccess(
          message: 'Excel exported successfully',
          filePath: path,
        ),
      );
      emit(currentState);
    });
  }

  Future<void> _onLoadPositionDetails(
    LoadPositionDetailsEvent event,
    Emitter<NetPositionState> emit,
  ) async {
    emit(const PositionDetailsLoading());
    final result = await getPositionDetails(
      PositionDetailsParams(symbol: event.symbol, userName: event.userName),
    );
    result.fold(
      (failure) => emit(PositionDetailsError(failure.message)),
      (positions) => emit(
        PositionDetailsLoaded(
          detailPositions: positions,
          symbol: event.symbol,
          userName: event.userName,
        ),
      ),
    );
  }
}
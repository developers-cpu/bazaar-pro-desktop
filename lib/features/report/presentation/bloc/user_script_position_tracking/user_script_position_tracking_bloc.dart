import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_user_script_position_tracking.dart';
import '../../../domain/entities/user_script_position_tracking.dart';
import 'user_script_position_tracking_event.dart';
import 'user_script_position_tracking_state.dart';
import 'package:bazarpro/features/users/domain/usecases/user/get_exchanges.dart';
import 'package:bazarpro/features/users/domain/usecases/user/get_symbols.dart'
    as user_symbols;

class UserScriptPositionTrackingBloc
    extends
        Bloc<UserScriptPositionTrackingEvent, UserScriptPositionTrackingState> {
  final GetUserScriptPositionTrackingUseCase getUserScriptPositionTracking;
  final GetExchanges getExchanges;
  final user_symbols.GetSymbols getSymbols;
  List<UserScriptPositionTracking> _allReports = [];
  List<String> _exchanges = [];
  List<String> _symbols = [];
  UserScriptPositionTrackingBloc({
    required this.getUserScriptPositionTracking,
    required this.getExchanges,
    required this.getSymbols,
  }) : super(UserScriptPositionTrackingInitial()) {
    on<LoadUserScriptPositionTracking>(_onLoadUserScriptPositionTracking);
    on<FilterUserScriptPositionTracking>(_onFilterUserScriptPositionTracking);
    on<ResetUserScriptPositionTrackingFilters>(
      _onResetUserScriptPositionTrackingFilters,
    );
  }
  Future<void> _onLoadUserScriptPositionTracking(
    LoadUserScriptPositionTracking event,
    Emitter<UserScriptPositionTrackingState> emit,
  ) async {
    emit(UserScriptPositionTrackingLoading());
    final results = await Future.wait([
      getUserScriptPositionTracking(),
      getExchanges(),
      getSymbols(),
    ]);
    final reportResult = results[0] as dynamic;
    final exchangeResult = results[1] as dynamic;
    final symbolResult = results[2] as dynamic;
    exchangeResult.fold(
      (failure) => _exchanges = [],
      (List<String> exchanges) => _exchanges = exchanges,
    );
    symbolResult.fold(
      (failure) => _symbols = [],
      (List<String> symbols) => _symbols = symbols,
    );
    reportResult.fold(
      (failure) =>
          emit(UserScriptPositionTrackingError(message: failure.message)),
      (reports) {
        _allReports = reports as List<UserScriptPositionTracking>;
        final userNames = _allReports.map((e) => e.userName).toSet().toList()
          ..sort();
        emit(
          UserScriptPositionTrackingLoaded(
            reports: _allReports,
            userNames: userNames,
            exchanges: _exchanges,
            symbols: _symbols,
          ),
        );
      },
    );
  }

  Future<void> _onFilterUserScriptPositionTracking(
    FilterUserScriptPositionTracking event,
    Emitter<UserScriptPositionTrackingState> emit,
  ) async {
    emit(UserScriptPositionTrackingLoading());
    final result = await getUserScriptPositionTracking(
      startDate: event.startDate,
      endDate: event.endDate,
      userId: event.userId,
      exchange: event.exchange,
      symbol: event.symbol,
    );
    result.fold(
      (failure) =>
          emit(UserScriptPositionTrackingError(message: failure.message)),
      (filteredReports) {
        final userNames = _allReports.map((e) => e.userName).toSet().toList()
          ..sort();
        emit(
          UserScriptPositionTrackingLoaded(
            reports: filteredReports,
            userNames: userNames,
            exchanges: _exchanges,
            symbols: _symbols,
            selectedUser: event.userId,
            selectedExchange: event.exchange,
            selectedSymbol: event.symbol,
            startDate: event.startDate,
            endDate: event.endDate,
          ),
        );
      },
    );
  }

  Future<void> _onResetUserScriptPositionTrackingFilters(
    ResetUserScriptPositionTrackingFilters event,
    Emitter<UserScriptPositionTrackingState> emit,
  ) async {
    emit(UserScriptPositionTrackingLoading());
    final result = await getUserScriptPositionTracking();
    result.fold(
      (failure) =>
          emit(UserScriptPositionTrackingError(message: failure.message)),
      (reports) {
        final userNames = reports.map((e) => e.userName).toSet().toList()
          ..sort();
        emit(
          UserScriptPositionTrackingLoaded(
            reports: reports,
            userNames: userNames,
            exchanges: _exchanges,
            symbols: _symbols,
            selectedUser: null,
            selectedExchange: null,
            selectedSymbol: null,
            startDate: null,
            endDate: null,
          ),
        );
      },
    );
  }
}
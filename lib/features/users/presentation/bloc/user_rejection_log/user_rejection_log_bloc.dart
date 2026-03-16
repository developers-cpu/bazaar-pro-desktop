import 'package:bazarpro/features/users/domain/entities/user_rejection_log/user_rejection_log.dart';
import 'package:bazarpro/features/users/domain/usecases/user_rejection_log/get_user_rejection_log_usecase.dart';
import 'package:bazarpro/features/users/domain/usecases/user_rejection_log/get_user_rejection_log_metadata_usecase.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_rejection_log_event.dart';
import 'user_rejection_log_state.dart';
class UserRejectionLogBloc
    extends Bloc<UserRejectionLogEvent, UserRejectionLogState> {
  final GetUserRejectionLog getUserRejectionLog;
  final GetUserRejectionLogMetadata getUserRejectionLogMetadata;
  UserRejectionLogBloc({
    required this.getUserRejectionLog,
    required this.getUserRejectionLogMetadata,
  }) : super(UserRejectionLogInitial()) {
    on<LoadUserRejectionLog>(_onLoadLogs);
    on<FilterUserRejectionLogs>(_onFilterLogs);
  }
  void _onLoadLogs(
    LoadUserRejectionLog event,
    Emitter<UserRejectionLogState> emit,
  ) async {
    emit(UserRejectionLogLoading());
    final logsResult = await getUserRejectionLog(event.userId);
    final metadataResult = await getUserRejectionLogMetadata(NoParams());
    logsResult.fold((failure) => emit(UserRejectionLogError(failure.message)), (
      logs,
    ) {
      metadataResult.fold(
        (metaFailure) => emit(
          UserRejectionLogLoaded(
            logs: logs,
            filteredLogs: logs,
            metadata: null,
          ),
        ),
        (metadata) => emit(
          UserRejectionLogLoaded(
            logs: logs,
            filteredLogs: logs,
            metadata: metadata,
          ),
        ),
      );
    });
  }
  void _onFilterLogs(
    FilterUserRejectionLogs event,
    Emitter<UserRejectionLogState> emit,
  ) {
    if (state is UserRejectionLogLoaded) {
      final currentState = state as UserRejectionLogLoaded;
      List<UserRejectionLog> filtered = currentState.logs;
      if (event.dateRange != null) {
        filtered = filtered.where((log) {
          return log.dateTime.isAfter(event.dateRange!.start) &&
              log.dateTime.isBefore(
                event.dateRange!.end.add(const Duration(days: 1)),
              );
        }).toList();
      }
      if (event.exchange != null && event.exchange != 'All') {
        filtered = filtered
            .where((log) => log.exchange == event.exchange)
            .toList();
      }
      if (event.symbol != null && event.symbol!.isNotEmpty) {
        filtered = filtered
            .where(
              (log) => log.symbol.toLowerCase().contains(
                event.symbol!.toLowerCase(),
              ),
            )
            .toList();
      }
      emit(
        currentState.copyWith(
          filteredLogs: filtered,
          selectedDateRange: event.dateRange,
          selectedExchange: event.exchange,
          selectedSymbol: event.symbol,
        ),
      );
    }
  }
}

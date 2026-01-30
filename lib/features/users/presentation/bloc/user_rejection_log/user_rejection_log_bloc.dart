import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_rejection_log.dart';
import 'user_rejection_log_event.dart';
import 'user_rejection_log_state.dart';

class UserRejectionLogBloc
    extends Bloc<UserRejectionLogEvent, UserRejectionLogState> {
  UserRejectionLogBloc() : super(UserRejectionLogLoading()) {
    on<LoadUserRejectionLogs>(_onLoadUserRejectionLogs);
    on<FilterUserRejectionLogs>(_onFilterUserRejectionLogs);
  }

  // Mock Data
  final List<UserRejectionLog> _mockLogs = [
    UserRejectionLog(
      id: '1',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'NSE',
      symbol: 'NIFTY25N0425550CE',
      type: 'BUY',
      qty: 95,
      price: 15000,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '2',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'NSE',
      symbol: 'NIFTY25N0425550CE',
      type: 'BUY',
      qty: 178,
      price: 5000,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '3',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'GOLD',
      type: 'SELL',
      qty: 125,
      price: 50000,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '4',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'GOLD',
      type: 'SELL',
      qty: 30003,
      price: 30003,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '5',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'GOLD05DEC',
      type: 'SELL',
      qty: 3000,
      price: 3000,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '6',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'GOLD05DEC',
      type: 'BUY',
      qty: 2000,
      price: 2000,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '7',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'SILVER',
      type: 'SELL',
      qty: 4000,
      price: 4000,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '8',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'CRUDEOIL20OCT',
      type: 'BUY',
      qty: 10000,
      price: 10000,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '9',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'SILVER05DEC',
      type: 'BUY',
      qty: 500,
      price: 1025006,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
    UserRejectionLog(
      id: '10',
      dateTime: DateTime.parse('2025-11-04 13:25:35'),
      status: 'rejected',
      userName: 'DEMO03',
      exchange: 'MCX',
      symbol: 'SILVER',
      type: 'BUY',
      qty: 75,
      price: 1025006,
      comment: 'SCRIPT BLOCKED IF YOU HAVE POSITION ONLY CLOSED BY MARKET',
    ),
  ];

  void _onLoadUserRejectionLogs(
    LoadUserRejectionLogs event,
    Emitter<UserRejectionLogState> emit,
  ) async {
    emit(UserRejectionLogLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    emit(UserRejectionLogLoaded(allLogs: _mockLogs, filteredLogs: _mockLogs));
  }

  void _onFilterUserRejectionLogs(
    FilterUserRejectionLogs event,
    Emitter<UserRejectionLogState> emit,
  ) {
    if (state is UserRejectionLogLoaded) {
      final currentState = state as UserRejectionLogLoaded;

      List<UserRejectionLog> filtered = currentState.allLogs.where((log) {
        bool matchesDate = true;
        if (event.dateRange != null) {
          matchesDate =
              log.dateTime.isAfter(
                event.dateRange!.start.subtract(const Duration(days: 1)),
              ) &&
              log.dateTime.isBefore(
                event.dateRange!.end.add(const Duration(days: 1)),
              );
        }

        bool matchesExchange = true;
        if (event.exchange != null) {
          matchesExchange = log.exchange == event.exchange;
        }

        bool matchesSymbol = true;
        if (event.symbol != null && event.symbol!.isNotEmpty) {
          matchesSymbol = log.symbol.toLowerCase().contains(
            event.symbol!.toLowerCase(),
          );
        }

        return matchesDate && matchesExchange && matchesSymbol;
      }).toList();

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

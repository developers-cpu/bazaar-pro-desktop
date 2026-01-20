import 'package:equatable/equatable.dart';
import '../../../domain/entities/intraday_history/intraday_history.dart';

abstract class IntradayHistoryState extends Equatable {
  const IntradayHistoryState();

  @override
  List<Object?> get props => [];
}

class IntradayHistoryInitial extends IntradayHistoryState {
  const IntradayHistoryInitial();
}

class IntradayHistoryLoading extends IntradayHistoryState {
  const IntradayHistoryLoading();
}

class IntradayHistoryLoaded extends IntradayHistoryState {
  final List<IntradayHistory> history;
  final int totalRecords;
  final String? sortColumn;
  final bool sortAscending;

  // Filter values
  final DateTime? selectedDate;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String? selectedTiming;

  // Filter options
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> timings;

  const IntradayHistoryLoaded({
    required this.history,
    required this.totalRecords,
    this.sortColumn,
    this.sortAscending = true,
    this.selectedDate,
    this.selectedExchange,
    this.selectedSymbol,
    this.selectedTiming,
    this.exchanges = const [],
    this.symbols = const [],
    this.timings = const [],
  });

  @override
  List<Object?> get props => [
    history,
    totalRecords,
    sortColumn,
    sortAscending,
    selectedDate,
    selectedExchange,
    selectedSymbol,
    selectedTiming,
    exchanges,
    symbols,
    timings,
  ];

  IntradayHistoryLoaded copyWith({
    List<IntradayHistory>? history,
    int? totalRecords,
    String? sortColumn,
    bool? sortAscending,
    DateTime? selectedDate,
    String? selectedExchange,
    String? selectedSymbol,
    String? selectedTiming,
    List<String>? exchanges,
    List<String>? symbols,
    List<String>? timings,
  }) {
    return IntradayHistoryLoaded(
      history: history ?? this.history,
      totalRecords: totalRecords ?? this.totalRecords,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedTiming: selectedTiming ?? this.selectedTiming,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
      timings: timings ?? this.timings,
    );
  }
}

class IntradayHistorySecondsView extends IntradayHistoryState {
  final List<IntradayHistory> history;
  final int totalRecords;
  final DateTime date;
  final String exchange;
  final String symbol;
  final DateTime startTime;
  final DateTime endTime;
  final String? sortColumn;
  final bool sortAscending;

  const IntradayHistorySecondsView({
    required this.history,
    required this.totalRecords,
    required this.date,
    required this.exchange,
    required this.symbol,
    required this.startTime,
    required this.endTime,
    this.sortColumn,
    this.sortAscending = true,
  });

  @override
  List<Object?> get props => [
    history,
    totalRecords,
    date,
    exchange,
    symbol,
    startTime,
    endTime,
    sortColumn,
    sortAscending,
  ];

  IntradayHistorySecondsView copyWith({
    List<IntradayHistory>? history,
    int? totalRecords,
    DateTime? date,
    String? exchange,
    String? symbol,
    DateTime? startTime,
    DateTime? endTime,
    String? sortColumn,
    bool? sortAscending,
  }) {
    return IntradayHistorySecondsView(
      history: history ?? this.history,
      totalRecords: totalRecords ?? this.totalRecords,
      date: date ?? this.date,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

class IntradayHistoryError extends IntradayHistoryState {
  final String message;

  const IntradayHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class IntradayHistoryExportSuccess extends IntradayHistoryState {
  final String message;
  final String filePath;

  const IntradayHistoryExportSuccess({
    required this.message,
    required this.filePath,
  });

  @override
  List<Object?> get props => [message, filePath];
}
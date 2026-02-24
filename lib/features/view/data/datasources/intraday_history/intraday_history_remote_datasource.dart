import 'package:dio/dio.dart';
import '../../models/intraday_history/intraday_history_model.dart';
import '../../../domain/entities/intraday_history/intraday_history.dart';

abstract class IntradayHistoryRemoteDataSource {
  Future<List<IntradayHistoryModel>> getIntradayHistory({
    DateTime? date,
    String? exchange,
    String? symbol,
    String? timing,
  });
  Future<List<IntradayHistoryModel>> getIntradayHistoryInSeconds({
    required DateTime date,
    required String exchange,
    required String symbol,
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<List<String>> getExchanges();
  Future<List<String>> getSymbols();
  Future<List<String>> getTimings();
  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date);
  Future<String> exportToPdf(List<IntradayHistoryModel> history);
  Future<String> exportToExcel(List<IntradayHistoryModel> history);
}

class IntradayHistoryRemoteDataSourceImpl
    implements IntradayHistoryRemoteDataSource {
  final Dio dio;
  IntradayHistoryRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<IntradayHistoryModel>> getIntradayHistory({
    DateTime? date,
    String? exchange,
    String? symbol,
    String? timing,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockIntradayHistory();
    } catch (e) {
      throw Exception('Failed to fetch intraday history: $e');
    }
  }

  @override
  Future<List<IntradayHistoryModel>> getIntradayHistoryInSeconds({
    required DateTime date,
    required String exchange,
    required String symbol,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockSecondsData(startTime, endTime);
    } catch (e) {
      throw Exception('Failed to fetch seconds data: $e');
    }
  }

  @override
  Future<List<String>> getExchanges() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        'NSE',
        'MCX',
        'CE/PE',
        'OTHERS',
        'COMEX',
        'CRYPTO',
        'GIFT',
        'FOREX',
      ];
    } catch (e) {
      throw Exception('Failed to fetch exchanges: $e');
    }
  }

  @override
  Future<List<String>> getSymbols() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        'SGX GIFTNIFTY Oct 28',
        'NSE NIFTY Oct 28',
        'NSE BANKNIFTY Oct 28',
        'MINI GOLDMINI Dec 05',
        'MINI SILVERMINI Dec 05',
        'OTHER DOW Dec 19',
        'OTHER NASDAQ Dec 19',
        'OTHER S & P Dec 19',
      ];
    } catch (e) {
      throw Exception('Failed to fetch symbols: $e');
    }
  }

  @override
  Future<List<String>> getTimings() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return ['Minute', '3 Minutes', '5 Minutes', '10 Minutes'];
    } catch (e) {
      throw Exception('Failed to fetch timings: $e');
    }
  }

  @override
  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        TimeSlot(
          startTime: DateTime(date.year, date.month, date.day, 0, 1),
          endTime: DateTime(date.year, date.month, date.day, 2, 40),
        ),
        TimeSlot(
          startTime: DateTime(date.year, date.month, date.day, 16, 35),
          endTime: DateTime(date.year, date.month, date.day, 23, 59),
        ),
        TimeSlot(
          startTime: DateTime(date.year, date.month, date.day, 7, 10),
          endTime: DateTime(date.year, date.month, date.day, 15, 30),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch time slots: $e');
    }
  }

  @override
  Future<String> exportToPdf(List<IntradayHistoryModel> history) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'intraday_history_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  @override
  Future<String> exportToExcel(List<IntradayHistoryModel> history) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'intraday_history_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }

  List<IntradayHistoryModel> _generateMockIntradayHistory() {
    final List<IntradayHistoryModel> history = [];
    final baseTime = DateTime(2025, 11, 4, 1, 25, 35);
    for (int i = 0; i < 125; i++) {
      final timestamp = baseTime.add(Duration(minutes: i));
      history.add(
        IntradayHistoryModel(
          id: 'intraday_$i',
          timestamp: timestamp,
          open: [
            50,
            29,
            125,
            30003,
            3000,
            2000,
            4000,
            10000,
            500,
            75,
            52,
            645,
          ][i % 12].toDouble(),
          high: [
            50,
            29,
            125,
            30003,
            3000,
            2000,
            4000,
            10000,
            500,
            75,
            52,
            645,
          ][i % 12].toDouble(),
          low: [
            4598,
            6453,
            50000,
            30003,
            3000,
            2000,
            4000,
            10000,
            1025006,
            1025006,
            0,
            1025006,
          ][i % 12].toDouble(),
          close: [
            4598,
            6453,
            50000,
            30003,
            3000,
            2000,
            4000,
            10000,
            1025006,
            1025006,
            0,
            1025006,
          ][i % 12].toDouble(),
          volume: [
            4598,
            6453,
            50000,
            30003,
            3000,
            2000,
            4000,
            10000,
            1025006,
            1025006,
            0,
            1025006,
          ][i % 12].toDouble(),
        ),
      );
    }
    return history;
  }

  List<IntradayHistoryModel> _generateMockSecondsData(
    DateTime startTime,
    DateTime endTime,
  ) {
    final List<IntradayHistoryModel> history = [];
    DateTime current = startTime;
    int id = 0;
    while (current.isBefore(endTime) || current.isAtSameMomentAs(endTime)) {
      history.add(
        IntradayHistoryModel(
          id: 'second_$id',
          timestamp: current,
          open: [
            50,
            29,
            125,
            30003,
            3000,
            2000,
            4000,
            10000,
            500,
            75,
            52,
            645,
          ][id % 12].toDouble(),
          high: [
            50,
            29,
            125,
            30003,
            3000,
            2000,
            4000,
            10000,
            500,
            75,
            52,
            645,
          ][id % 12].toDouble(),
          low: [
            4598,
            6453,
            50000,
            30003,
            3000,
            2000,
            4000,
            10000,
            1025006,
            1025006,
            0,
            1025006,
          ][id % 12].toDouble(),
          close: [
            4598,
            6453,
            50000,
            30003,
            3000,
            2000,
            4000,
            10000,
            1025006,
            1025006,
            0,
            1025006,
          ][id % 12].toDouble(),
          volume: [
            4598,
            6453,
            50000,
            30003,
            3000,
            2000,
            4000,
            10000,
            1025006,
            1025006,
            0,
            1025006,
          ][id % 12].toDouble(),
        ),
      );
      current = current.add(const Duration(seconds: 1));
      id++;
    }
    return history;
  }
}

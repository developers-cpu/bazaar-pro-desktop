import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/intraday_history/intraday_history.dart';

abstract class IntradayHistoryRepository {
  Future<Either<Failure, List<IntradayHistory>>> getIntradayHistory({
    DateTime? date,
    String? exchange,
    String? symbol,
    String? timing,
  });
  Future<Either<Failure, List<IntradayHistory>>> getIntradayHistoryInSeconds({
    required DateTime date,
    required String exchange,
    required String symbol,
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, List<String>>> getTimings();
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots(DateTime date);
  Future<Either<Failure, String>> exportToPdf(List<IntradayHistory> history);
  Future<Either<Failure, String>> exportToExcel(List<IntradayHistory> history);
}

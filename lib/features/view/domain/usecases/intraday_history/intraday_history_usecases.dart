import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/intraday_history/intraday_history.dart';
import '../../repositories/intraday_history/intraday_history_repository.dart';
class GetIntradayHistory
    implements UseCase<List<IntradayHistory>, IntradayHistoryParams> {
  final IntradayHistoryRepository repository;
  GetIntradayHistory(this.repository);
  @override
  Future<Either<Failure, List<IntradayHistory>>> call(
      IntradayHistoryParams params) {
    return repository.getIntradayHistory(
      date: params.date,
      exchange: params.exchange,
      symbol: params.symbol,
      timing: params.timing,
    );
  }
}
class IntradayHistoryParams {
  final DateTime? date;
  final String? exchange;
  final String? symbol;
  final String? timing;
  const IntradayHistoryParams({
    this.date,
    this.exchange,
    this.symbol,
    this.timing,
  });
}
class GetIntradayHistoryInSeconds
    implements UseCase<List<IntradayHistory>, IntradayHistorySecondsParams> {
  final IntradayHistoryRepository repository;
  GetIntradayHistoryInSeconds(this.repository);
  @override
  Future<Either<Failure, List<IntradayHistory>>> call(
      IntradayHistorySecondsParams params) {
    return repository.getIntradayHistoryInSeconds(
      date: params.date,
      exchange: params.exchange,
      symbol: params.symbol,
      startTime: params.startTime,
      endTime: params.endTime,
    );
  }
}
class IntradayHistorySecondsParams {
  final DateTime date;
  final String exchange;
  final String symbol;
  final DateTime startTime;
  final DateTime endTime;
  const IntradayHistorySecondsParams({
    required this.date,
    required this.exchange,
    required this.symbol,
    required this.startTime,
    required this.endTime,
  });
}
class GetIntradayExchanges implements UseCase<List<String>, NoParams> {
  final IntradayHistoryRepository repository;
  GetIntradayExchanges(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}
class GetIntradaySymbols implements UseCase<List<String>, NoParams> {
  final IntradayHistoryRepository repository;
  GetIntradaySymbols(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}
class GetIntradayTimings implements UseCase<List<String>, NoParams> {
  final IntradayHistoryRepository repository;
  GetIntradayTimings(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getTimings();
  }
}
class GetAvailableTimeSlots implements UseCase<List<TimeSlot>, DateTime> {
  final IntradayHistoryRepository repository;
  GetAvailableTimeSlots(this.repository);
  @override
  Future<Either<Failure, List<TimeSlot>>> call(DateTime date) {
    return repository.getAvailableTimeSlots(date);
  }
}
class ExportIntradayToPdf implements UseCase<String, List<IntradayHistory>> {
  final IntradayHistoryRepository repository;
  ExportIntradayToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(List<IntradayHistory> history) {
    return repository.exportToPdf(history);
  }
}
class ExportIntradayToExcel implements UseCase<String, List<IntradayHistory>> {
  final IntradayHistoryRepository repository;
  ExportIntradayToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(List<IntradayHistory> history) {
    return repository.exportToExcel(history);
  }
}

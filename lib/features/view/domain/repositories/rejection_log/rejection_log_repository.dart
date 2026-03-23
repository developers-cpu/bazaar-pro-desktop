import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/rejection_log/rejection_log.dart';

abstract class RejectionLogRepository {
  Future<Either<Failure, List<RejectionLog>>> getRejectionLogs();
  Future<Either<Failure, List<RejectionLog>>> getRejectionLogsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
  });
  Future<Either<Failure, List<String>>> getClients();
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, String>> exportToPdf(List<RejectionLog> logs);
  Future<Either<Failure, String>> exportToExcel(List<RejectionLog> logs);
}

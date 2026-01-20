import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/rejection_log/rejection_log.dart';
import '../../repositories/rejection_log/rejection_log_repository.dart';

/// Get all rejection logs
class GetRejectionLogs implements UseCase<List<RejectionLog>, NoParams> {
  final RejectionLogRepository repository;

  GetRejectionLogs(this.repository);

  @override
  Future<Either<Failure, List<RejectionLog>>> call(NoParams params) {
    return repository.getRejectionLogs();
  }
}

/// Get rejection logs with filters
class GetRejectionLogsWithFilters
    implements UseCase<List<RejectionLog>, RejectionLogFilterParams> {
  final RejectionLogRepository repository;

  GetRejectionLogsWithFilters(this.repository);

  @override
  Future<Either<Failure, List<RejectionLog>>> call(
      RejectionLogFilterParams params) {
    return repository.getRejectionLogsWithFilters(
      startDate: params.startDate,
      endDate: params.endDate,
      client: params.client,
      exchange: params.exchange,
      symbol: params.symbol,
    );
  }
}

/// Filter parameters
class RejectionLogFilterParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? client;
  final String? exchange;
  final String? symbol;

  const RejectionLogFilterParams({
    this.startDate,
    this.endDate,
    this.client,
    this.exchange,
    this.symbol,
  });
}

/// Get clients
class GetRejectionLogClients implements UseCase<List<String>, NoParams> {
  final RejectionLogRepository repository;

  GetRejectionLogClients(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getClients();
  }
}

/// Get exchanges
class GetRejectionLogExchanges implements UseCase<List<String>, NoParams> {
  final RejectionLogRepository repository;

  GetRejectionLogExchanges(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}

/// Get symbols
class GetRejectionLogSymbols implements UseCase<List<String>, NoParams> {
  final RejectionLogRepository repository;

  GetRejectionLogSymbols(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}

/// Export to PDF
class ExportRejectionLogsToPdf implements UseCase<String, List<RejectionLog>> {
  final RejectionLogRepository repository;

  ExportRejectionLogsToPdf(this.repository);

  @override
  Future<Either<Failure, String>> call(List<RejectionLog> logs) {
    return repository.exportToPdf(logs);
  }
}

/// Export to Excel
class ExportRejectionLogsToExcel
    implements UseCase<String, List<RejectionLog>> {
  final RejectionLogRepository repository;

  ExportRejectionLogsToExcel(this.repository);

  @override
  Future<Either<Failure, String>> call(List<RejectionLog> logs) {
    return repository.exportToExcel(logs);
  }
}
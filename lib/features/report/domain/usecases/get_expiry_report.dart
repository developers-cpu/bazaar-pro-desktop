import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/expiry_report_repository.dart';
import '../../data/models/expiry_report_model.dart';

class GetExpiryReport {
  final ExpiryReportRepository repository;

  GetExpiryReport(this.repository);

  Future<Either<Failure, List<ExpiryReportModel>>> call({
    String? exchange,
    String? month,
  }) {
    return repository.getExpiryReport(exchange: exchange, month: month);
  }
}

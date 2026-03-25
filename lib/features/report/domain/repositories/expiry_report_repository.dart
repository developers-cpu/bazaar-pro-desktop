import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/expiry_report_model.dart';

abstract class ExpiryReportRepository {
  Future<Either<Failure, List<ExpiryReportModel>>> getExpiryReport({
    String? exchange,
    String? month,
  });
}

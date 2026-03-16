import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/settlement_report.dart';

abstract class SettlementReportRepository {
  Future<Either<Failure, SettlementReport>> getSettlementReport({
    required String dateRange,
    String? userId,
  });
}

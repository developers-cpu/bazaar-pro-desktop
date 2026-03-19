import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/settlement_sharing_report.dart';

abstract class SettlementSharingReportRepository {
  Future<Either<Failure, SettlementSharingReport>> getSettlementSharingReport({
    required String dateRange,
    String? userId,
  });
}
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profit_and_loss_report.dart';

abstract class ProfitAndLossReportRepository {
  Future<Either<Failure, List<ProfitAndLossReport>>> getProfitAndLossReport({
    String? userId,
  });
}

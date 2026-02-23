import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profit_and_loss_report.dart';
import '../repositories/profit_and_loss_report_repository.dart';

class GetProfitAndLossReportUseCase {
  final ProfitAndLossReportRepository repository;
  GetProfitAndLossReportUseCase({required this.repository});
  Future<Either<Failure, List<ProfitAndLossReport>>> call({
    String? userId,
  }) async {
    return await repository.getProfitAndLossReport(userId: userId);
  }
}

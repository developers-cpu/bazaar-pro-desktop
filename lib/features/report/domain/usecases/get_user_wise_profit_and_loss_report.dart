import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_wise_profit_and_loss_report.dart';
import '../repositories/user_wise_profit_and_loss_repository.dart';

class GetUserWiseProfitAndLossReportUseCase {
  final UserWiseProfitAndLossRepository repository;
  GetUserWiseProfitAndLossReportUseCase({required this.repository});
  Future<Either<Failure, List<UserWiseProfitAndLossReport>>> call({
    String? userId,
    String? startDate,
    String? endDate,
  }) async {
    return await repository.getUserWiseProfitAndLossReport(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
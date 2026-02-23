import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_wise_profit_and_loss_report.dart';
abstract class UserWiseProfitAndLossRepository {
  Future<Either<Failure, List<UserWiseProfitAndLossReport>>>
  getUserWiseProfitAndLossReport({
    String? userId,
    String? startDate,
    String? endDate,
  });
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_wise_profit_and_loss_report.dart';
import '../../domain/repositories/user_wise_profit_and_loss_repository.dart';
import '../datasources/user_wise_profit_and_loss/user_wise_profit_and_loss_remote_datasource.dart';
class UserWiseProfitAndLossRepositoryImpl
    implements UserWiseProfitAndLossRepository {
  final UserWiseProfitAndLossRemoteDataSource dataSource;
  UserWiseProfitAndLossRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserWiseProfitAndLossReport>>>
  getUserWiseProfitAndLossReport({
    String? userId,
    String? startDate,
    String? endDate,
  }) async {
    return await dataSource.getUserWiseProfitAndLossReport(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

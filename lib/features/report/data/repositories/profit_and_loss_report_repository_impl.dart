import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/profit_and_loss_report.dart';
import '../../domain/repositories/profit_and_loss_report_repository.dart';
import '../datasources/profit_and_loss_report/profit_and_loss_report_remote_datasource.dart';

class ProfitAndLossReportRepositoryImpl
    implements ProfitAndLossReportRepository {
  final ProfitAndLossReportRemoteDataSource dataSource;
  ProfitAndLossReportRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<ProfitAndLossReport>>> getProfitAndLossReport({
    String? userId,
  }) async {
    try {
      final result = await dataSource.getProfitAndLossReport(userId: userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
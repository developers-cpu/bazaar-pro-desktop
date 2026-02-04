import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/settlement_report.dart';
import '../../domain/repositories/settlement_report_repository.dart';
import '../datasources/settlement_report_remote_datasource.dart';
class SettlementReportRepositoryImpl implements SettlementReportRepository {
  final SettlementReportRemoteDataSource remoteDataSource;
  SettlementReportRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, SettlementReport>> getSettlementReport({
    required String dateRange,
    String? userId,
  }) async {
    try {
      final report = await remoteDataSource.getSettlementReport(
        dateRange: dateRange,
        userId: userId,
      );
      return Right(report);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

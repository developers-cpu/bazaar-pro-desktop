import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/settlement_sharing_report.dart';
import '../../domain/repositories/settlement_sharing_report_repository.dart';
import '../datasources/settlement_sharing_report_remote_datasource.dart';

class SettlementSharingReportRepositoryImpl
    implements SettlementSharingReportRepository {
  final SettlementSharingReportRemoteDataSource remoteDataSource;
  SettlementSharingReportRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, SettlementSharingReport>> getSettlementSharingReport({
    required String dateRange,
    String? userId,
  }) async {
    try {
      final report = await remoteDataSource.getSettlementSharingReport(
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

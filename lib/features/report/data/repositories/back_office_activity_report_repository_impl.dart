import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/back_office_activity_report.dart';
import '../../domain/repositories/back_office_activity_report_repository.dart';
import '../datasources/back_office_activity_report/back_office_activity_report_remote_datasource.dart';

class BackOfficeActivityReportRepositoryImpl
    implements BackOfficeActivityReportRepository {
  final BackOfficeActivityReportRemoteDataSource dataSource;
  BackOfficeActivityReportRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<BackOfficeActivityReport>>>
  getBackOfficeActivityReport() async {
    try {
      final result = await dataSource.getBackOfficeActivityReport();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
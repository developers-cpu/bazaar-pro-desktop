import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/activity_report.dart';
import '../../domain/repositories/activity_report_repository.dart';
import '../datasources/activity_report/activity_report_remote_datasource.dart';

class ActivityReportRepositoryImpl implements ActivityReportRepository {
  final ActivityReportRemoteDataSource dataSource;
  ActivityReportRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<ActivityReport>>> getActivityReport({
    String? user,
    DateTime? startDate,
    DateTime? endDate,
    String? editUserType,
  }) async {
    try {
      final result = await dataSource.getActivityReport(
        user: user,
        startDate: startDate,
        endDate: endDate,
        editUserType: editUserType,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/activity_report.dart';

abstract class ActivityReportRepository {
  Future<Either<Failure, List<ActivityReport>>> getActivityReport({
    String? user,
    DateTime? startDate,
    DateTime? endDate,
    String? editUserType,
  });
}

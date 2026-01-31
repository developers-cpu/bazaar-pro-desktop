import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/activity_report.dart';
import '../repositories/activity_report_repository.dart';

class GetActivityReportUseCase {
  final ActivityReportRepository repository;

  GetActivityReportUseCase({required this.repository});

  Future<Either<Failure, List<ActivityReport>>> call({
    String? user,
    DateTime? startDate,
    DateTime? endDate,
    String? editUserType,
  }) async {
    return await repository.getActivityReport(
      user: user,
      startDate: startDate,
      endDate: endDate,
      editUserType: editUserType,
    );
  }
}

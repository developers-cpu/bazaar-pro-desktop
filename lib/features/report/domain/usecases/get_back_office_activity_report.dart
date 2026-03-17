import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/back_office_activity_report.dart';
import '../repositories/back_office_activity_report_repository.dart';

class GetBackOfficeActivityReportUseCase {
  final BackOfficeActivityReportRepository repository;
  GetBackOfficeActivityReportUseCase({required this.repository});
  Future<Either<Failure, List<BackOfficeActivityReport>>> call() async {
    return await repository.getBackOfficeActivityReport();
  }
}

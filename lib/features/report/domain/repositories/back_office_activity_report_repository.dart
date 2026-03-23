import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/back_office_activity_report.dart';

abstract class BackOfficeActivityReportRepository {
  Future<Either<Failure, List<BackOfficeActivityReport>>>
  getBackOfficeActivityReport();
}

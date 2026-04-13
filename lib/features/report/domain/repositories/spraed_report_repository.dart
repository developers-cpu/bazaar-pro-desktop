import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/spraed_report_entity.dart';

abstract class SpraedReportRepository {
  Future<Either<Failure, List<SpraedReportEntity>>> getSpraedReport({String? exchange});
}

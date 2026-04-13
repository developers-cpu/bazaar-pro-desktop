import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/spraed_report_entity.dart';
import '../repositories/spraed_report_repository.dart';

class GetSpraedReportUseCase implements UseCase<List<SpraedReportEntity>, Params> {
  final SpraedReportRepository repository;

  GetSpraedReportUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpraedReportEntity>>> call(Params params) async {
    return await repository.getSpraedReport(exchange: params.exchange);
  }
}

class Params {
  final String? exchange;

  Params({this.exchange});
}

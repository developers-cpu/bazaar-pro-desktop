import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../entities/exchange_wise_pl/exchange_wise_pl_report.dart';
import '../../repositories/exchange_wise_pl/exchange_wise_pl_repository.dart';

class GetExchangeWisePLReport
    implements UseCase<List<ExchangeWisePLReport>, NoParams> {
  final ExchangeWisePLRepository repository;
  GetExchangeWisePLReport(this.repository);
  @override
  Future<Either<Failure, List<ExchangeWisePLReport>>> call(
    NoParams params,
  ) async {
    return await repository.getExchangeWisePLReport();
  }
}

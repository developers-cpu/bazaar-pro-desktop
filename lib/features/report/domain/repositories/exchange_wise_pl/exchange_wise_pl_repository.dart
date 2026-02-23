import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/report/domain/entities/exchange_wise_pl/exchange_wise_pl_report.dart';
import 'package:dartz/dartz.dart';

abstract class ExchangeWisePLRepository {
  Future<Either<Failure, List<ExchangeWisePLReport>>> getExchangeWisePLReport();
}

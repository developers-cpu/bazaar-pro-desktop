import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/exchange_wise_pl/exchange_wise_pl_report.dart';
import '../../../domain/repositories/exchange_wise_pl/exchange_wise_pl_repository.dart';
import '../../datasources/exchange_wise_pl/exchange_wise_pl_remote_datasource.dart';

class ExchangeWisePLRepositoryImpl implements ExchangeWisePLRepository {
  final ExchangeWisePLRemoteDataSource dataSource;
  ExchangeWisePLRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<ExchangeWisePLReport>>>
  getExchangeWisePLReport() async {
    try {
      final result = await dataSource.getExchangeWisePLReport();
      return result.map((models) => models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

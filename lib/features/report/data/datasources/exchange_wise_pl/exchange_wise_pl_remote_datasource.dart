import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../models/exchange_wise_pl/exchange_wise_pl_report_model.dart';

abstract class ExchangeWisePLRemoteDataSource {
  Future<Either<Failure, List<ExchangeWisePLReportModel>>>
  getExchangeWisePLReport();
}

class ExchangeWisePLRemoteDataSourceImpl
    implements ExchangeWisePLRemoteDataSource {
  @override
  Future<Either<Failure, List<ExchangeWisePLReportModel>>>
  getExchangeWisePLReport() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<ExchangeWisePLReportModel> mockData = [
      const ExchangeWisePLReportModel(
        exchange: 'NSE',
        m2m: -500.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'MCX',
        m2m: 1000000.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'GIFTNIFTY',
        m2m: -500.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'CE/PE',
        m2m: 1000000.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'OTHERS',
        m2m: -500.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'COMEX',
        m2m: 1000000.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'CRYPTO',
        m2m: -500.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'FOREX',
        m2m: -500.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
      const ExchangeWisePLReportModel(
        exchange: 'USSTOCK',
        m2m: 1000000.00,
        realisedPL: 1000000.00,
        brokerage: 36200.00,
        totalPL: 124191.00,
      ),
    ];

    return Right(mockData);
  }
}

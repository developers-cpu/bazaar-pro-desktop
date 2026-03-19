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
    final List<ExchangeWisePLReportModel> mockData = _generateDummyExchangeWisePLReports();
    return Right(mockData);
  }

  List<ExchangeWisePLReportModel> _generateDummyExchangeWisePLReports() {
    final List<String> exchanges = [
      'NSE',
      'MCX',
      'GIFTNIFTY',
      'CE/PE',
      'OTHERS',
      'COMEX',
      'CRYPTO',
      'FOREX',
      'USSTOCK',
      'BTX',
      'LME'
    ];

    final List<ExchangeWisePLReportModel> list = [];

    for (int i = 1; i <= 35; i++) {
      final String exch = exchanges[i % exchanges.length];
      final double m2m = (i % 3 == 0) ? -(i * 1000.0) : (i * 50000.0);
      final double realisedPL = (i * 100000.0);
      final double brk = i * 2000.0;
      final double totalPL = realisedPL + m2m - brk;

      list.add(
        ExchangeWisePLReportModel(
          exchange: '$exch${i > exchanges.length ? '_$i' : ''}',
          m2m: m2m,
          realisedPL: realisedPL,
          brokerage: brk,
          totalPL: totalPL,
          ourPercent: totalPL * 0.9,
        ),
      );
    }
    return list;
  }
}
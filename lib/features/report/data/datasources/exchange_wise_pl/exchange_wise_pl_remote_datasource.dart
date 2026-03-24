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
    final List<ExchangeWisePLReportModel> mockData =
        _generateDummyExchangeWisePLReports();
    return Right(mockData);
  }

  List<ExchangeWisePLReportModel> _generateDummyExchangeWisePLReports() {
    final List<String> exchanges = ['NSE'];

    final List<ExchangeWisePLReportModel> list = [];

    for (int i = 1; i <= 30; i++) {
      final String exch = 'NSE $i';
      final double m2m = (i % 3 == 0) ? -(i * 1000.0) : (i * 5000.0);
      final double realisedPL = (i * 10000.0);
      final double brk = i * 200.0;
      final double totalPL = realisedPL + m2m - brk;

      list.add(
        ExchangeWisePLReportModel(
          exchange: exch,
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

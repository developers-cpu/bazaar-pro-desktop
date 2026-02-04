import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/symbol_wise_position_report.dart';
import '../../domain/repositories/symbol_wise_position_report_repository.dart';
import '../datasources/symbol_wise_pl/symbol_wise_position_report_remote_datasource.dart';

class SymbolWisePositionReportRepositoryImpl
    implements SymbolWisePositionReportRepository {
  final SymbolWisePositionReportRemoteDataSource dataSource;

  SymbolWisePositionReportRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<SymbolWisePositionReport>>>
  getSymbolWisePositionReport({String? exchange, String? symbol}) async {
    try {
      final result = await dataSource.getSymbolWisePositionReport(
        exchange: exchange,
        symbol: symbol,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

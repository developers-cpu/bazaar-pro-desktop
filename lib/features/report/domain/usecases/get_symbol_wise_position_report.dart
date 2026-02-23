import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/symbol_wise_position_report_repository.dart';
import '../entities/symbol_wise_position_report.dart';
class GetSymbolWisePositionReportUseCase {
  final SymbolWisePositionReportRepository repository;
  GetSymbolWisePositionReportUseCase({required this.repository});
  Future<Either<Failure, List<SymbolWisePositionReport>>> call({
    String? exchange,
    String? symbol,
  }) async {
    return await repository.getSymbolWisePositionReport(
      exchange: exchange,
      symbol: symbol,
    );
  }
}

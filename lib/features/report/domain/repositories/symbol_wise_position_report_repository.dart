import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/symbol_wise_position_report.dart';

abstract class SymbolWisePositionReportRepository {
  Future<Either<Failure, List<SymbolWisePositionReport>>>
  getSymbolWisePositionReport({String? exchange, String? symbol});
}
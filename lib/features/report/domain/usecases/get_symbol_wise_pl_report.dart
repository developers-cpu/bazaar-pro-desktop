import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/symbol_wise_pl_report.dart';
import '../../domain/repositories/symbol_wise_pl_repository.dart';

class GetSymbolWisePLReport {
  final SymbolWisePLRepository repository;

  GetSymbolWisePLReport(this.repository);

  Future<Either<Failure, List<SymbolWisePLReport>>> call({
    String? exchange,
    String? symbol,
  }) async {
    return await repository.getSymbolWisePLReport(
      exchange: exchange,
      symbol: symbol,
    );
  }
}

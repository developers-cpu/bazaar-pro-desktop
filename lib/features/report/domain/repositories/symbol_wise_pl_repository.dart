import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/symbol_wise_pl_report.dart';
import '../../domain/entities/symbol_trade_log.dart';
import '../../domain/entities/symbol_open_position.dart';

abstract class SymbolWisePLRepository {
  Future<Either<Failure, List<SymbolWisePLReport>>> getSymbolWisePLReport({
    String? exchange,
    String? symbol,
  });

  Future<Either<Failure, List<SymbolTradeLog>>> getSymbolTradeLog({
    String? symbol,
  });

  Future<Either<Failure, List<SymbolOpenPosition>>> getSymbolOpenPosition({
    String? symbol,
  });
}

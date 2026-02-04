import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/symbol_wise_pl_report.dart';
import '../../domain/entities/symbol_trade_log.dart';
import '../../domain/entities/symbol_open_position.dart';
import '../../domain/repositories/symbol_wise_pl_repository.dart';
import '../datasources/symbol_wise_pl_remote_datasource.dart';

class SymbolWisePLRepositoryImpl implements SymbolWisePLRepository {
  final SymbolWisePLRemoteDataSource dataSource;

  SymbolWisePLRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<SymbolWisePLReport>>> getSymbolWisePLReport({
    String? exchange,
    String? symbol,
  }) async {
    try {
      final result = await dataSource.getSymbolWisePLReport(
        exchange: exchange,
        symbol: symbol,
      );
      
      return result.map((models) => models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SymbolTradeLog>>> getSymbolTradeLog({
    String? symbol,
  }) async {
    try {
      final result = await dataSource.getSymbolTradeLog(symbol: symbol);
      return result.map((models) => models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SymbolOpenPosition>>> getSymbolOpenPosition({
    String? symbol,
  }) async {
    try {
      final result = await dataSource.getSymbolOpenPosition(symbol: symbol);
      return result.map((models) => models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

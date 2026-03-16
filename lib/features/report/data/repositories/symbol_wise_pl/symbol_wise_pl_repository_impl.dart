import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/report/domain/entities/symbol_open_position.dart';
import 'package:bazarpro/features/report/domain/entities/symbol_trade_log.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/symbol_wise_pl/symbol_wise_pl_report.dart';
import '../../../domain/repositories/symbol_wise_pl/symbol_wise_pl_repository.dart';
import '../../datasources/symbol_wise_pl/symbol_wise_pl_remote_datasource.dart';

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
    String? exchange,
    String? user,
    String? type,
    DateTimeRange? dateRange,
  }) async {
    try {
      final result = await dataSource.getSymbolTradeLog(
        symbol: symbol,
        exchange: exchange,
        user: user,
        type: type,
        dateRange: dateRange,
      );
      return result.map((models) => models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SymbolOpenPosition>>> getSymbolOpenPosition({
    String? symbol,
    String? exchange,
    String? user,
  }) async {
    try {
      final result = await dataSource.getSymbolOpenPosition(
        symbol: symbol,
        exchange: exchange,
        user: user,
      );
      return result.map((models) => models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

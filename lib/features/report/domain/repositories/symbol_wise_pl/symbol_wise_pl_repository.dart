import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/report/domain/entities/symbol_open_position.dart';
import 'package:bazarpro/features/report/domain/entities/symbol_trade_log.dart';
import 'package:bazarpro/features/report/domain/entities/symbol_wise_pl/symbol_wise_pl_report.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';


abstract class SymbolWisePLRepository {
  Future<Either<Failure, List<SymbolWisePLReport>>> getSymbolWisePLReport({
    String? exchange,
    String? symbol,
  });

  Future<Either<Failure, List<SymbolTradeLog>>> getSymbolTradeLog({
    String? symbol,
    String? exchange,
    String? user,
    String? type,
    DateTimeRange? dateRange,
  });

  Future<Either<Failure, List<SymbolOpenPosition>>> getSymbolOpenPosition({
    String? symbol,
    String? exchange,
    String? user,
  });
}

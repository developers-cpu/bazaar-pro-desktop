import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/report/data/models/symbol_open_position_model.dart';
import 'package:bazarpro/features/report/data/models/symbol_trade_log_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../models/symbol_wise_pl/symbol_wise_pl_report_model.dart';

abstract class SymbolWisePLRemoteDataSource {
  Future<Either<Failure, List<SymbolWisePLReportModel>>> getSymbolWisePLReport({
    String? exchange,
    String? symbol,
  });
  Future<Either<Failure, List<SymbolTradeLogModel>>> getSymbolTradeLog({
    String? symbol,
    String? exchange,
    String? user,
    String? type,
    DateTimeRange? dateRange,
  });
  Future<Either<Failure, List<SymbolOpenPositionModel>>> getSymbolOpenPosition({
    String? symbol,
    String? exchange,
    String? user,
  });
}

class SymbolWisePLRemoteDataSourceImpl implements SymbolWisePLRemoteDataSource {
  @override
  Future<Either<Failure, List<SymbolWisePLReportModel>>> getSymbolWisePLReport({
    String? exchange,
    String? symbol,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<SymbolWisePLReportModel> mockData =
        _generateDummySymbolWisePLReport();
    final filtered = mockData.where((item) {
      if (exchange != null &&
          exchange.isNotEmpty &&
          item.exchange.toLowerCase() != exchange.toLowerCase()) {
        return false;
      }
      if (symbol != null && symbol.isNotEmpty) {
        return item.symbol.toLowerCase() == symbol.toLowerCase();
      }
      return true;
    }).toList();
    return Right(filtered);
  }

  List<SymbolWisePLReportModel> _generateDummySymbolWisePLReport() {
    final List<String> exchanges = ['NSE', 'MCX', 'NFO'];
    final List<String> symbols = [
      'BTCUSD31DEC',
      'ETHUSD31DEC',
      'GOLDPETAL',
      'GOLD05DEC',
      'SILVERMIC',
      'CRUDEOIL',
      'NATGAS',
      'COPPER',
      'RELIANCE',
      'TCS',
      'INFY',
      'HDFCBANK',
      'NIFTY',
      'BANKNIFTY',
    ];

    final List<SymbolWisePLReportModel> list = [];
    for (int i = 1; i <= 35; i++) {
      final String exch = exchanges[i % exchanges.length];
      final String sym = symbols[i % symbols.length];
      final double relPL = (i % 3 == 0) ? -(i * 1200.50) : (i * 850.75);
      final double m2m = (i % 2 == 0) ? (i * 500.0) : -(i * 300.25);
      final double brk = i * 15.50;
      final double netPL = relPL + m2m - brk;

      list.add(
        SymbolWisePLReportModel(
          id: i.toString(),
          exchange: exch,
          symbol: '$sym-${i + 100}',
          releasePL: relPL,
          m2m: m2m,
          brokerage: brk,
          netPL: netPL,
          netQty: i * 5.0,
          netQtyPercent: (i % 5).toDouble(),
          avgPrice: 1000.0 + (i * 10),
          wbaPrice: 1005.0 + (i * 10),
          cmp: 1010.0 + (i * 10),
          plPercent: (i % 10).toDouble(),
          brokeragePercent: (i % 4).toDouble(),
        ),
      );
    }
    return list;
  }

  @override
  Future<Either<Failure, List<SymbolTradeLogModel>>> getSymbolTradeLog({
    String? symbol,
    String? exchange,
    String? user,
    String? type,
    DateTimeRange? dateRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<SymbolTradeLogModel> mockData = _generateDummySymbolTradeLogs(
      symbol,
    );
    final filtered = mockData.where((item) {
      if (symbol != null && symbol.isNotEmpty && item.symbol != symbol) {
        return false;
      }
      if (exchange != null &&
          exchange.isNotEmpty &&
          item.exchange != exchange) {
        return false;
      }
      return true;
    }).toList();
    return Right(filtered);
  }

  List<SymbolTradeLogModel> _generateDummySymbolTradeLogs(
    String? targetSymbol,
  ) {
    final List<SymbolTradeLogModel> list = [];
    for (int i = 1; i <= 35; i++) {
      list.add(
        SymbolTradeLogModel(
          sequence: (309400 + i).toString(),
          userName: 'USER_${i.toString().padLeft(3, '0')}',
          pUser: 'DEMO_${(i % 5).toString()}',
          exchange: i % 2 == 0 ? 'NSE' : 'MCX',
          symbol: targetSymbol ?? (i % 2 == 0 ? 'BTCUSD31DEC' : 'GOLD05DEC'),
          buySell: i % 3 == 0 ? 'SELL' : 'BUY',
          tradeType: 'Market',
          qty: (i * 100).toDouble() * (i % 3 == 0 ? -1 : 1),
          lot: 1.00,
          pl: (i * 500).toDouble(),
          validity: 'Market',
          tradePrice: 120000.00 + (i * 10),
          brokerage: (i * 2).toDouble(),
          netPrice: 120000.00 + (i * 10) + (i * 2),
          orderDateTime:
              '22/11/25 03:06:${(i % 60).toString().padLeft(2, '0')} PM',
          executionDateTime:
              '22/11/25 03:06:${(i % 60).toString().padLeft(2, '0')} PM',
          referencePrice: 0.00,
        ),
      );
    }
    return list;
  }

  @override
  Future<Either<Failure, List<SymbolOpenPositionModel>>> getSymbolOpenPosition({
    String? symbol,
    String? exchange,
    String? user,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<SymbolOpenPositionModel> mockData =
        _generateDummySymbolOpenPositions(symbol, exchange);
    final filtered = mockData.where((item) {
      if (symbol != null && symbol.isNotEmpty && item.symbol != symbol) {
        return false;
      }
      if (exchange != null &&
          exchange.isNotEmpty &&
          item.exchange != exchange) {
        return false;
      }
      if (user != null && user.isNotEmpty) {
        return item.name.toLowerCase().contains(user.toLowerCase());
      }
      return true;
    }).toList();
    return Right(filtered);
  }

  List<SymbolOpenPositionModel> _generateDummySymbolOpenPositions(
    String? targetSymbol,
    String? targetExchange,
  ) {
    final List<SymbolOpenPositionModel> list = [];
    for (int i = 1; i <= 35; i++) {
      list.add(
        SymbolOpenPositionModel(
          name: 'HOLDER_${i.toString().padLeft(3, '0')}',
          type: i % 4 == 0 ? 'Master' : 'Client',
          exchange: targetExchange ?? (i % 2 == 0 ? 'MCX' : 'NSE'),
          symbol: targetSymbol ?? (i % 2 == 0 ? 'GOLD05DEC' : 'BTCUSD31DEC'),
          buyQty: (i * 100).toDouble(),
          sellQty: (i % 5 == 0) ? (i * 50).toDouble() : 0.0,
          netQty:
              (i * 100).toDouble() - ((i % 5 == 0) ? (i * 50).toDouble() : 0.0),
          netAvgPrice: 90000.00 + (i * 100),
          cmp: 90000.00 + (i * 110),
          m2m: (i * 1000).toDouble(),
          ourPercent: (i % 20).toDouble(),
          user: i.toString(),
          days: i % 10,
        ),
      );
    }
    return list;
  }
}

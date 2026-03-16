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
    final List<SymbolWisePLReportModel> mockData = [
      const SymbolWisePLReportModel(
        id: '1',
        exchange: 'NSE',
        symbol: 'BTCUSD31DEC',
        releasePL: 0.00,
        m2m: 38970.00,
        brokerage: 1601.40,
        netPL: 37369.35,
        netQty: 0.0,
        netQtyPercent: 0.0,
        avgPrice: 38970.00,
        wbaPrice: 0.0,
        cmp: 0.0,
        plPercent: 0.0,
        brokeragePercent: 0.0,
      ),
      const SymbolWisePLReportModel(
        id: '2',
        exchange: 'NSE',
        symbol: 'ETHUSD31DEC',
        releasePL: 25.76,
        m2m: 5361.99,
        brokerage: 1.10,
        netPL: 5386.65,
        netQty: 0.0,
        netQtyPercent: 0.0,
        avgPrice: 5361.99,
        wbaPrice: 0.0,
        cmp: 0.0,
        plPercent: 0.0,
        brokeragePercent: 0.0,
      ),
      const SymbolWisePLReportModel(
        id: '3',
        exchange: 'MCX',
        symbol: 'GOLDPETAL',
        releasePL: 2000.00,
        m2m: 2000.00,
        brokerage: 50.00,
        netPL: 1950.00,
        netQty: 10.0,
        netQtyPercent: 5.0,
        avgPrice: 59000.00,
        wbaPrice: 59050.00,
        cmp: 59200.00,
        plPercent: 15.00,
        brokeragePercent: 10.00,
      ),
      const SymbolWisePLReportModel(
        id: '4',
        exchange: 'NSE',
        symbol: 'GOLD05DEC',
        releasePL: -36200.00,
        m2m: -500.00,
        brokerage: 1000000.00,
        netPL: 124191.00,
        netQty: 0.0,
        netQtyPercent: 0.0,
        avgPrice: 0.0,
        wbaPrice: 0.0,
        cmp: 0.0,
        plPercent: 0.0,
        brokeragePercent: 0.0,
      ),
      const SymbolWisePLReportModel(
        id: '5',
        exchange: 'NSE',
        symbol: 'GOLD05DEC',
        releasePL: 36200.00,
        m2m: 1000000.00,
        brokerage: 1000000.00,
        netPL: 124191.00,
        netQty: 0.0,
        netQtyPercent: 0.0,
        avgPrice: 0.0,
        wbaPrice: 0.0,
        cmp: 0.0,
        plPercent: 0.0,
        brokeragePercent: 0.0,
      ),
      const SymbolWisePLReportModel(
        id: '6',
        exchange: 'NSE',
        symbol: 'GOLD05DEC',
        releasePL: -36200.00,
        m2m: -500.00,
        brokerage: 1000000.00,
        netPL: 124191.00,
        netQty: 0.0,
        netQtyPercent: 0.0,
        avgPrice: 0.0,
        wbaPrice: 0.0,
        cmp: 0.0,
        plPercent: 0.0,
        brokeragePercent: 0.0,
      ),
      const SymbolWisePLReportModel(
        id: '7',
        exchange: 'NSE',
        symbol: 'GOLD05DEC',
        releasePL: 36200.00,
        m2m: 1000000.00,
        brokerage: 1000000.00,
        netPL: 124191.00,
        netQty: 0.0,
        netQtyPercent: 0.0,
        avgPrice: 0.0,
        wbaPrice: 0.0,
        cmp: 0.0,
        plPercent: 0.0,
        brokeragePercent: 0.0,
      ),
    ];
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
  @override
  Future<Either<Failure, List<SymbolTradeLogModel>>> getSymbolTradeLog({
    String? symbol,
    String? exchange,
    String? user,
    String? type,
    DateTimeRange? dateRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<SymbolTradeLogModel> mockData = [
      const SymbolTradeLogModel(
        sequence: '309405',
        userName: 'PATIL',
        pUser: 'DEMO',
        exchange: 'MCX',
        symbol: 'GOLD05DEC',
        buySell: 'SELL',
        tradeType: 'Market',
        qty: -500.00,
        lot: 1.00,
        pl: 36200.00,
        validity: 'Market',
        tradePrice: 124191.00,
        brokerage: 0.00,
        netPrice: 124191.00,
        orderDateTime: '22/11/25 03:06:34 PM',
        executionDateTime: '22/11/25 03:06:34 PM',
        referencePrice: 0.00,
      ),
      const SymbolTradeLogModel(
        sequence: '309405',
        userName: 'DEMO4',
        pUser: 'DEMO49',
        exchange: 'NSE',
        symbol: 'GOLD05DEC',
        buySell: 'BUY',
        tradeType: 'Market',
        qty: 1000000.0,
        lot: 1.00,
        pl: 36200.00,
        validity: 'Market',
        tradePrice: 124191.00,
        brokerage: 0.00,
        netPrice: 124191.00,
        orderDateTime: '22/11/25 03:06:34 PM',
        executionDateTime: '22/11/25 03:06:34 PM',
        referencePrice: 0.00,
      ),
      const SymbolTradeLogModel(
        sequence: '333444',
        userName: 'CRYPTO_USER',
        pUser: 'MASTER',
        exchange: 'NSE',
        symbol: 'BTCUSD31DEC',
        buySell: 'BUY',
        tradeType: 'Market',
        qty: 1.0,
        lot: 1.00,
        pl: 500.00,
        validity: 'Day',
        tradePrice: 40000.00,
        brokerage: 10.00,
        netPrice: 40010.00,
        orderDateTime: '25/12/25 10:00:00 AM',
        executionDateTime: '25/12/25 10:00:05 AM',
        referencePrice: 0.00,
      ),
      const SymbolTradeLogModel(
        sequence: '555666',
        userName: 'GOLD_USER',
        pUser: 'MASTER',
        exchange: 'MCX',
        symbol: 'GOLDPETAL',
        buySell: 'SELL',
        tradeType: 'Market',
        qty: 10.0,
        lot: 1.00,
        pl: 1500.00,
        validity: 'Day',
        tradePrice: 59000.00,
        brokerage: 20.00,
        netPrice: 58980.00,
        orderDateTime: '26/12/25 11:30:00 AM',
        executionDateTime: '26/12/25 11:30:05 AM',
        referencePrice: 0.00,
      ),
    ];
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
  @override
  Future<Either<Failure, List<SymbolOpenPositionModel>>> getSymbolOpenPosition({
    String? symbol,
    String? exchange,
    String? user,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<SymbolOpenPositionModel> mockData = [
      const SymbolOpenPositionModel(
        name: 'DEMO11',
        type: 'Master',
        exchange: 'MCX',
        symbol: 'GOLD05DEC',
        buyQty: 10000.0,
        sellQty: 0.00,
        netQty: 1000.0,
        netAvgPrice: 90792.00,
        cmp: 124536.00,
        m2m: 124536.00,
        ourPercent: 0.00,
        user: '1',
        days: 1,
      ),
      const SymbolOpenPositionModel(
        name: 'DEMO012',
        type: 'Client',
        exchange: 'MCX',
        symbol: 'GOLD05DEC',
        buyQty: 0.00,
        sellQty: 1.00,
        netQty: -1.00,
        netAvgPrice: 130319.73,
        cmp: 124191.00,
        m2m: 124191.00,
        ourPercent: 0.00,
        user: '-',
        days: 2,
      ),
      const SymbolOpenPositionModel(
        name: 'CRYPTO_HOLDER',
        type: 'Client',
        exchange: 'NSE',
        symbol: 'BTCUSD31DEC',
        buyQty: 5.0,
        sellQty: 0.00,
        netQty: 5.0,
        netAvgPrice: 38000.00,
        cmp: 38970.00,
        m2m: 4850.00,
        ourPercent: 0.00,
        user: '2',
        days: 5,
      ),
      const SymbolOpenPositionModel(
        name: 'GOLD_HOLDER',
        type: 'Master',
        exchange: 'MCX',
        symbol: 'GOLDPETAL',
        buyQty: 20.0,
        sellQty: 0.00,
        netQty: 20.0,
        netAvgPrice: 58000.00,
        cmp: 59200.00,
        m2m: 24000.00,
        ourPercent: 0.00,
        user: '3',
        days: 3,
      ),
    ];
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
}

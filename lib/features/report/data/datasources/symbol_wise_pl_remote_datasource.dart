import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/symbol_wise_pl_report_model.dart';
import '../models/symbol_trade_log_model.dart';
import '../models/symbol_open_position_model.dart';

abstract class SymbolWisePLRemoteDataSource {
  Future<Either<Failure, List<SymbolWisePLReportModel>>> getSymbolWisePLReport({
    String? exchange,
    String? symbol,
  });

  Future<Either<Failure, List<SymbolTradeLogModel>>> getSymbolTradeLog({
    String? symbol,
  });

  Future<Either<Failure, List<SymbolOpenPositionModel>>> getSymbolOpenPosition({
    String? symbol,
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
    ];

    if (symbol != null && symbol.isNotEmpty) {
      
      
    }

    return Right(mockData);
  }

  @override
  Future<Either<Failure, List<SymbolOpenPositionModel>>> getSymbolOpenPosition({
    String? symbol,
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
    ];

    return Right(mockData);
  }
}

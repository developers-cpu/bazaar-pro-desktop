import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/trades/trade.dart';
import '../../../domain/repositories/trades/trades_repository.dart';
import '../../datasources/trades/trades_remote_datasource.dart';
import '../../models/trades/trade_model.dart';


class TradesRepositoryImpl implements TradesRepository {
  final TradesRemoteDataSource remoteDataSource;

  TradesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Trade>>> getTrades() async {
    try {
      final trades = await remoteDataSource.getTrades();
      return Right(trades);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Trade>>> getTradesWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
  }) async {
    try {
      final trades = await remoteDataSource.getTradesWithFilters(
        startDate: startDate,
        endDate: endDate,
        client: client,
        exchange: exchange,
        symbol: symbol,
        orderType: orderType,
      );
      return Right(trades);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getClients() async {
    try {
      final clients = await remoteDataSource.getClients();
      return Right(clients);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getExchanges() async {
    try {
      final exchanges = await remoteDataSource.getExchanges();
      return Right(exchanges);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSymbols() async {
    try {
      final symbols = await remoteDataSource.getSymbols();
      return Right(symbols);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getOrderTypes() async {
    try {
      final orderTypes = await remoteDataSource.getOrderTypes();
      return Right(orderTypes);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToPdf(List<Trade> trades) async {
    try {
      final models = trades.map((t) => TradeModel.fromEntity(t)).toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(List<Trade> trades) async {
    try {
      final models = trades.map((t) => TradeModel.fromEntity(t)).toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }
}
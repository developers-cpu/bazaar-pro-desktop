import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/rejected_trade/rejected_trade.dart';
import '../../../domain/repositories/rejected_trade/rejected_trade_repository.dart';
import '../../datasources/rejected_trade/rejected_trade_remote_datasource.dart';
import '../../models/rejected_trade/rejected_trade_model.dart';

class RejectedTradeRepositoryImpl implements RejectedTradeRepository {
  final RejectedTradeRemoteDataSource remoteDataSource;

  RejectedTradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RejectedTrade>>> getRejectedTrades() async {
    try {
      final trades = await remoteDataSource.getRejectedTrades();
      return Right(trades);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RejectedTrade>>> getRejectedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    try {
      final trades = await remoteDataSource.getRejectedTradesWithFilters(
        userType: userType,
        user: user,
        exchange: exchange,
        symbol: symbol,
      );
      return Right(trades);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUserTypes() async {
    try {
      final userTypes = await remoteDataSource.getUserTypes();
      return Right(userTypes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getExchanges() async {
    try {
      final exchanges = await remoteDataSource.getExchanges();
      return Right(exchanges);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSymbols() async {
    try {
      final symbols = await remoteDataSource.getSymbols();
      return Right(symbols);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToPdf(
    List<RejectedTrade> trades,
  ) async {
    try {
      final models = trades
          .map((t) => RejectedTradeModel.fromEntity(t))
          .toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(
    List<RejectedTrade> trades,
  ) async {
    try {
      final models = trades
          .map((t) => RejectedTradeModel.fromEntity(t))
          .toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

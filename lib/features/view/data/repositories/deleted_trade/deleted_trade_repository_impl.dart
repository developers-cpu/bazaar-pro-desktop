import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/deleted_trade/deleted_trade.dart';
import '../../../domain/repositories/deleted_trade/deleted_trade_repository.dart';
import '../../datasources/deleted_trade/deleted_trade_remote_datasource.dart';
import '../../models/deleted_trade/deleted_trade_model.dart';
class DeletedTradeRepositoryImpl implements DeletedTradeRepository {
  final DeletedTradeRemoteDataSource remoteDataSource;
  DeletedTradeRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<DeletedTrade>>> getDeletedTrades() async {
    try {
      final trades = await remoteDataSource.getDeletedTrades();
      return Right(trades);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<DeletedTrade>>> getDeletedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  }) async {
    try {
      final trades = await remoteDataSource.getDeletedTradesWithFilters(
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
  Future<Either<Failure, String>> exportToPdf(List<DeletedTrade> trades) async {
    try {
      final models = trades
          .map((t) => DeletedTradeModel.fromEntity(t))
          .toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, String>> exportToExcel(
    List<DeletedTrade> trades,
  ) async {
    try {
      final models = trades
          .map((t) => DeletedTradeModel.fromEntity(t))
          .toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/market_item.dart';
import '../../domain/repositories/market_watch_repository.dart';
import '../datasources/market_watch_local_datasource.dart';
import '../models/market_item_model.dart';

class MarketWatchRepositoryImpl implements MarketWatchRepository {
  final MarketWatchLocalDataSource localDataSource;

  MarketWatchRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MarketItem>>> getMarketItems() async {
    try {

      final marketItemModels = await localDataSource.getMarketItems();

      final entities = marketItemModels.map((model) => model.toEntity()).toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<MarketItem>>> getMarketItemsByExchange(
      String exchange) async {
    try {

      final marketItemModels = await localDataSource.getMarketItems();

      final filteredModels = marketItemModels
          .where((model) => model.exchange == exchange)
          .toList();

      final entities = filteredModels.map((model) => model.toEntity()).toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<MarketItem>>> getMarketItemsBySymbol(
      String symbol) async {
    try {

      final marketItemModels = await localDataSource.getMarketItems();

      final filteredModels = marketItemModels
          .where((model) => model.symbol == symbol)
          .toList();

      final entities = filteredModels.map((model) => model.toEntity()).toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MarketItem>> addMarketItem(MarketItem item) async {
    try {

      final model = MarketItemModel.fromEntity(item);

      final addedModel = await localDataSource.addMarketItem(model);

      return Right(addedModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMarketItem(String id) async {
    try {

      final result = await localDataSource.deleteMarketItem(id);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MarketItem>> updateMarketItem(MarketItem item) async {
    try {

      final model = MarketItemModel.fromEntity(item);

      final updatedModel = await localDataSource.updateMarketItem(model);

      return Right(updatedModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on NoDataException catch (e) {
      return Left(NoDataFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }
}

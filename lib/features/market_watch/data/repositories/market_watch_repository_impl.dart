import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/market_item.dart';
import '../../domain/repositories/market_watch_repository.dart';
import '../datasources/market_watch_local_datasource.dart';
import '../models/market_item_model.dart';

/// Implementation of MarketWatchRepository
/// Bridges the domain and data layers
/// Handles error conversion from exceptions to failures
class MarketWatchRepositoryImpl implements MarketWatchRepository {
  final MarketWatchLocalDataSource localDataSource;

  /// Constructor injection of data source dependency
  MarketWatchRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MarketItem>>> getMarketItems() async {
    try {
      // Get data from local data source
      final marketItemModels = await localDataSource.getMarketItems();
      
      // Convert models to entities
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
      // Get all items from local data source
      final marketItemModels = await localDataSource.getMarketItems();
      
      // Filter by exchange
      final filteredModels = marketItemModels
          .where((model) => model.exchange == exchange)
          .toList();
      
      // Convert models to entities
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
      // Get all items from local data source
      final marketItemModels = await localDataSource.getMarketItems();
      
      // Filter by symbol
      final filteredModels = marketItemModels
          .where((model) => model.symbol == symbol)
          .toList();
      
      // Convert models to entities
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
      // Convert entity to model
      final model = MarketItemModel.fromEntity(item);
      
      // Add to local data source
      final addedModel = await localDataSource.addMarketItem(model);
      
      // Convert back to entity
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
      // Delete from local data source
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
      // Convert entity to model
      final model = MarketItemModel.fromEntity(item);
      
      // Update in local data source
      final updatedModel = await localDataSource.updateMarketItem(model);
      
      // Convert back to entity
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

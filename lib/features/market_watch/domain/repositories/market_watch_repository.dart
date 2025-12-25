import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/market_item.dart';

/// Repository interface for market watch operations
/// Defines the contract that data layer must implement
/// Returns Either<Failure, Data> for error handling
abstract class MarketWatchRepository {
  /// Get all market items from the data source
  /// Returns Either Left for failure or Right for success with list of items
  Future<Either<Failure, List<MarketItem>>> getMarketItems();
  
  /// Get filtered market items by exchange
  /// Parameters:
  /// - exchange: The exchange to filter by (NSE, MCX, etc.)
  /// Returns filtered list of market items
  Future<Either<Failure, List<MarketItem>>> getMarketItemsByExchange(String exchange);
  
  /// Get filtered market items by symbol
  /// Parameters:
  /// - symbol: The symbol to filter by (NIFTY, GOLD, etc.)
  /// Returns filtered list of market items
  Future<Either<Failure, List<MarketItem>>> getMarketItemsBySymbol(String symbol);
  
  /// Add a new market item
  /// Parameters:
  /// - item: The market item to add
  /// Returns Either Left for failure or Right for success with added item
  Future<Either<Failure, MarketItem>> addMarketItem(MarketItem item);
  
  /// Delete a market item by ID
  /// Parameters:
  /// - id: The ID of the item to delete
  /// Returns Either Left for failure or Right for success with true
  Future<Either<Failure, bool>> deleteMarketItem(String id);
  
  /// Update an existing market item
  /// Parameters:
  /// - item: The market item with updated data
  /// Returns Either Left for failure or Right for success with updated item
  Future<Either<Failure, MarketItem>> updateMarketItem(MarketItem item);
}

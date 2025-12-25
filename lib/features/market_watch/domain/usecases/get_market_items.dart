import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/market_item.dart';
import '../repositories/market_watch_repository.dart';

/// Use case for getting all market items
/// Implements the business logic for fetching market data
/// Returns Either Left for failure or Right for success with list of items
class GetMarketItems implements UseCase<List<MarketItem>, NoParams> {
  final MarketWatchRepository repository;

  /// Constructor injection of repository dependency
  GetMarketItems(this.repository);

  @override
  Future<Either<Failure, List<MarketItem>>> call(NoParams params) async {
    // Call repository to get market items
    return await repository.getMarketItems();
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/market_item.dart';
import '../repositories/market_watch_repository.dart';

/// Use case for adding a new market item
/// Implements the business logic for adding market data
/// Returns Either Left for failure or Right for success with added item
class AddMarketItem implements UseCase<MarketItem, AddMarketItemParams> {
  final MarketWatchRepository repository;

  /// Constructor injection of repository dependency
  AddMarketItem(this.repository);

  @override
  Future<Either<Failure, MarketItem>> call(AddMarketItemParams params) async {
    // Call repository to add market item
    return await repository.addMarketItem(params.item);
  }
}

/// Parameters for AddMarketItem use case
class AddMarketItemParams extends Equatable {
  final MarketItem item;

  const AddMarketItemParams({required this.item});

  @override
  List<Object> get props => [item];
}

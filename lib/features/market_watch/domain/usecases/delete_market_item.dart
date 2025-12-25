import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/market_watch_repository.dart';

/// Use case for deleting a market item
/// Implements the business logic for removing market data
/// Returns Either Left for failure or Right for success with boolean result
class DeleteMarketItem implements UseCase<bool, DeleteMarketItemParams> {
  final MarketWatchRepository repository;

  /// Constructor injection of repository dependency
  DeleteMarketItem(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteMarketItemParams params) async {
    // Call repository to delete market item
    return await repository.deleteMarketItem(params.id);
  }
}

/// Parameters for DeleteMarketItem use case
class DeleteMarketItemParams extends Equatable {
  final String id;

  const DeleteMarketItemParams({required this.id});

  @override
  List<Object> get props => [id];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/market_item.dart';
import '../repositories/market_watch_repository.dart';
class AddMarketItem implements UseCase<MarketItem, AddMarketItemParams> {
  final MarketWatchRepository repository;
  AddMarketItem(this.repository);
  @override
  Future<Either<Failure, MarketItem>> call(AddMarketItemParams params) async {
    return await repository.addMarketItem(params.item);
  }
}
class AddMarketItemParams extends Equatable {
  final MarketItem item;
  const AddMarketItemParams({required this.item});
  @override
  List<Object> get props => [item];
}

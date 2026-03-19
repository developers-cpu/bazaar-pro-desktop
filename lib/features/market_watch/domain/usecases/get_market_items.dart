import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/market_item.dart';
import '../repositories/market_watch_repository.dart';

class GetMarketItems implements UseCase<List<MarketItem>, NoParams> {
  final MarketWatchRepository repository;
  GetMarketItems(this.repository);
  @override
  Future<Either<Failure, List<MarketItem>>> call(NoParams params) async {
    return await repository.getMarketItems();
  }
}
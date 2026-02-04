import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/market_watch_repository.dart';
class DeleteMarketItem implements UseCase<bool, DeleteMarketItemParams> {
  final MarketWatchRepository repository;
  DeleteMarketItem(this.repository);
  @override
  Future<Either<Failure, bool>> call(DeleteMarketItemParams params) async {
    return await repository.deleteMarketItem(params.id);
  }
}
class DeleteMarketItemParams extends Equatable {
  final String id;
  const DeleteMarketItemParams({required this.id});
  @override
  List<Object> get props => [id];
}

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/pending_orders/pending_order.dart';
import '../../repositories/pending_orders/pending_orders_repository.dart';

class GetPendingOrders implements UseCase<List<PendingOrder>, NoParams> {
  final PendingOrdersRepository repository;
  GetPendingOrders(this.repository);
  @override
  Future<Either<Failure, List<PendingOrder>>> call(NoParams params) async {
    return await repository.getPendingOrders();
  }
}

class GetPendingOrdersWithFilters
    implements UseCase<List<PendingOrder>, FilterParams> {
  final PendingOrdersRepository repository;
  GetPendingOrdersWithFilters(this.repository);
  @override
  Future<Either<Failure, List<PendingOrder>>> call(FilterParams params) async {
    return await repository.getPendingOrdersWithFilters(
      client: params.client,
      exchange: params.exchange,
      symbol: params.symbol,
      type: params.type,
    );
  }
}

class FilterParams {
  final String? client;
  final String? exchange;
  final String? symbol;
  final String? type;
  const FilterParams({this.client, this.exchange, this.symbol, this.type});
}

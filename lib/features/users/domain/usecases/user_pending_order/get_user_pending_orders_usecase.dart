import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_pending_order/user_pending_order.dart';
import 'package:bazarpro/features/users/domain/repositories/user_pending_order/user_pending_order_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserPendingOrders {
  final UserPendingOrderRepository repository;

  GetUserPendingOrders(this.repository);

  Future<Either<Failure, List<UserPendingOrder>>> call(String userId) {
    return repository.getUserPendingOrders(userId);
  }
}

import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_pending_order/user_pending_order.dart';
import 'package:bazarpro/features/users/domain/entities/user_pending_order/user_pending_order_metadata.dart';
import 'package:dartz/dartz.dart';


abstract class UserPendingOrderRepository {
  Future<Either<Failure, List<UserPendingOrder>>> getUserPendingOrders(
    String userId,
  );
  Future<Either<Failure, UserPendingOrderMetadata>> getPendingOrderMetadata();
}

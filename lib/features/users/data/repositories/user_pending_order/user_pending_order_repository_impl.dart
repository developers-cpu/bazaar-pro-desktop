import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_pending_order/user_pending_order.dart';
import '../../../domain/entities/user_pending_order/user_pending_order_metadata.dart';
import '../../../domain/repositories/user_pending_order/user_pending_order_repository.dart';
import '../../datasources/user_pending_order/user_pending_order_datasource.dart';

class UserPendingOrderRepositoryImpl implements UserPendingOrderRepository {
  final UserPendingOrderDataSource dataSource;
  UserPendingOrderRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserPendingOrder>>> getUserPendingOrders(
    String userId,
  ) async {
    try {
      final models = await dataSource.getUserPendingOrders(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserPendingOrderMetadata>>
  getPendingOrderMetadata() async {
    try {
      final model = await dataSource.getPendingOrderMetadata();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

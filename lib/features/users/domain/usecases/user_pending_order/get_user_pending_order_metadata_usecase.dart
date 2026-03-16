import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/entities/user_pending_order/user_pending_order_metadata.dart';
import 'package:bazarpro/features/users/domain/repositories/user_pending_order/user_pending_order_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserPendingOrderMetadata
    implements UseCase<UserPendingOrderMetadata, NoParams> {
  final UserPendingOrderRepository repository;
  GetUserPendingOrderMetadata(this.repository);
  @override
  Future<Either<Failure, UserPendingOrderMetadata>> call(NoParams params) {
    return repository.getPendingOrderMetadata();
  }
}

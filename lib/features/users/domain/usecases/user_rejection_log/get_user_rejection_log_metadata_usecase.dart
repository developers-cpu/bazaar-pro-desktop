import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/entities/user_rejection_log/user_rejection_log_metadata.dart';
import 'package:bazarpro/features/users/domain/repositories/user_rejection_log/user_rejection_log_repository.dart';
import 'package:dartz/dartz.dart';
class GetUserRejectionLogMetadata
    implements UseCase<UserRejectionLogMetadata, NoParams> {
  final UserRejectionLogRepository repository;
  GetUserRejectionLogMetadata(this.repository);
  @override
  Future<Either<Failure, UserRejectionLogMetadata>> call(NoParams params) {
    return repository.getRejectionLogMetadata();
  }
}

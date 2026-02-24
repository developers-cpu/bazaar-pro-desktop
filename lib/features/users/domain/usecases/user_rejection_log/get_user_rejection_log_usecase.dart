import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_rejection_log/user_rejection_log.dart';
import 'package:bazarpro/features/users/domain/repositories/user_rejection_log/user_rejection_log_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserRejectionLog {
  final UserRejectionLogRepository repository;
  GetUserRejectionLog(this.repository);
  Future<Either<Failure, List<UserRejectionLog>>> call(String userId) {
    return repository.getUserRejectionLogs(userId);
  }
}

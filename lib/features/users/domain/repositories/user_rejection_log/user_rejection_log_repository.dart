import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_rejection_log/user_rejection_log.dart';
import 'package:bazarpro/features/users/domain/entities/user_rejection_log/user_rejection_log_metadata.dart';
import 'package:dartz/dartz.dart';

abstract class UserRejectionLogRepository {
  Future<Either<Failure, List<UserRejectionLog>>> getUserRejectionLogs(
    String userId,
  );
  Future<Either<Failure, UserRejectionLogMetadata>> getRejectionLogMetadata();
}
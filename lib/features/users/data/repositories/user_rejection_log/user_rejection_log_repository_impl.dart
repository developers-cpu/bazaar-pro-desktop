import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_rejection_log/user_rejection_log.dart';
import '../../../domain/entities/user_rejection_log/user_rejection_log_metadata.dart';
import '../../../domain/repositories/user_rejection_log/user_rejection_log_repository.dart';
import '../../datasources/user_rejection_log/user_rejection_log_datasource.dart';

class UserRejectionLogRepositoryImpl implements UserRejectionLogRepository {
  final UserRejectionLogDataSource dataSource;
  UserRejectionLogRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserRejectionLog>>> getUserRejectionLogs(
    String userId,
  ) async {
    try {
      final models = await dataSource.getUserRejectionLogs(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserRejectionLogMetadata>>
  getRejectionLogMetadata() async {
    try {
      final model = await dataSource.getRejectionLogMetadata();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

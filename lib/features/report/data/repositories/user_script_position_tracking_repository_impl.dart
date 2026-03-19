import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_script_position_tracking.dart';
import '../../domain/repositories/user_script_position_tracking_repository.dart';
import '../datasources/user_script_position_tracking/user_script_position_tracking_remote_datasource.dart';

class UserScriptPositionTrackingRepositoryImpl
    implements UserScriptPositionTrackingRepository {
  final UserScriptPositionTrackingRemoteDataSource dataSource;
  UserScriptPositionTrackingRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserScriptPositionTracking>>>
  getUserScriptPositionTracking({
    String? startDate,
    String? endDate,
    String? userId,
    String? exchange,
    String? symbol,
  }) async {
    try {
      final result = await dataSource.getUserScriptPositionTracking(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
        exchange: exchange,
        symbol: symbol,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
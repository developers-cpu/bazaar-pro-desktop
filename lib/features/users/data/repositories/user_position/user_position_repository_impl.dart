import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_position/user_position.dart';
import '../../../domain/repositories/user_position/user_position_repository.dart';
import '../../datasources/user_position/user_position_datasource.dart';

class UserPositionRepositoryImpl implements UserPositionRepository {
  final UserPositionDataSource dataSource;
  UserPositionRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserPosition>>> getUserPositions(
    String userId,
  ) async {
    try {
      final positions = await dataSource.getUserPositions(userId);
      return Right(positions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

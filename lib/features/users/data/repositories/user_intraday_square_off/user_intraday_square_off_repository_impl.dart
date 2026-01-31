import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_intraday_square_off/user_intraday_square_off.dart';
import '../../../domain/repositories/user_intraday_square_off/user_intraday_square_off_repository.dart';
import '../../datasources/user_intraday_square_off/user_intraday_square_off_datasource.dart';

class UserIntradaySquareOffRepositoryImpl
    implements UserIntradaySquareOffRepository {
  final UserIntradaySquareOffDataSource dataSource;

  UserIntradaySquareOffRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<UserIntradaySquareOff>>> getUserIntradaySquareOff(
    String userId,
  ) async {
    try {
      final result = await dataSource.getUserIntradaySquareOff(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

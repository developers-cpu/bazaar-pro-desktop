import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_intraday_square_off/user_intraday_square_off.dart';
import 'package:dartz/dartz.dart';


abstract class UserIntradaySquareOffRepository {
  Future<Either<Failure, List<UserIntradaySquareOff>>> getUserIntradaySquareOff(
    String userId,
  );
}

import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_intraday_square_off/user_intraday_square_off.dart';
import 'package:bazarpro/features/users/domain/repositories/user_intraday_square_off/user_intraday_square_off_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserIntradaySquareOff {
  final UserIntradaySquareOffRepository repository;
  GetUserIntradaySquareOff(this.repository);
  Future<Either<Failure, List<UserIntradaySquareOff>>> call(
    String userId,
  ) async {
    return await repository.getUserIntradaySquareOff(userId);
  }
}

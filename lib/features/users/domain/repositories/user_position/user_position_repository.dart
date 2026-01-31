import 'package:bazarpro/features/users/domain/entities/user_position/user_position.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';


abstract class UserPositionRepository {
  Future<Either<Failure, List<UserPosition>>> getUserPositions(String userId);
}

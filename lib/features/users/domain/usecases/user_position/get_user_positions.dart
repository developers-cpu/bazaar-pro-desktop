import 'package:bazarpro/features/users/domain/entities/user_position/user_position.dart';
import 'package:bazarpro/features/users/domain/repositories/user_position/user_position_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
class GetUserPositions implements UseCase<List<UserPosition>, String> {
  final UserPositionRepository repository;
  GetUserPositions(this.repository);
  @override
  Future<Either<Failure, List<UserPosition>>> call(String userId) async {
    return await repository.getUserPositions(userId);
  }
}

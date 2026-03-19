import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart' show NoParams, UseCase;
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUsers implements UseCase<List<User>, NoParams> {
  final UserRepository repository;
  GetUsers(this.repository);
  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getUsers();
  }
}
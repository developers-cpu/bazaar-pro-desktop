import 'package:dartz/dartz.dart';
import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';

class GetNestedUsers {
  final UserRepository repository;

  GetNestedUsers(this.repository);

  Future<Either<Failure, List<User>>> call(String parentUserId) async {
    return await repository.getNestedUsers(parentUserId);
  }
}

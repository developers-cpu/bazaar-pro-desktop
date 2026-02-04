import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';
import 'package:dartz/dartz.dart';
class GetUsersWithFilters implements UseCase<List<User>, UserFilterParams> {
  final UserRepository repository;
  GetUsersWithFilters(this.repository);
  @override
  Future<Either<Failure, List<User>>> call(UserFilterParams params) async {
    return await repository.getUsersWithFilters(
      userType: params.userType,
      userStatus: params.userStatus,
    );
  }
}
class UserFilterParams {
  final String? userType;
  final String? userStatus;
  const UserFilterParams({this.userType, this.userStatus});
}

import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';
import 'package:dartz/dartz.dart';
class ExportUsersToPdf implements UseCase<String, ExportUsersParams> {
  final UserRepository repository;
  ExportUsersToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(ExportUsersParams params) async {
    return await repository.exportToPdf(params.users);
  }
}
class ExportUsersParams {
  final List<User> users;
  const ExportUsersParams({required this.users});
}

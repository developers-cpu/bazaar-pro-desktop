import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Get Users Use Case
class GetUsers implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  GetUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getUsers();
  }
}

/// Get Users With Filters Use Case
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

/// Get User Types Use Case (synchronous)
class GetUserTypes {
  final UserRepository repository;

  GetUserTypes(this.repository);

  List<String> call() {
    return repository.getUserTypes();
  }
}

/// Get User Statuses Use Case (synchronous)
class GetUserStatuses {
  final UserRepository repository;

  GetUserStatuses(this.repository);

  List<String> call() {
    return repository.getUserStatuses();
  }
}

/// Export Users to PDF Use Case
class ExportUsersToPdf implements UseCase<String, ExportUsersParams> {
  final UserRepository repository;

  ExportUsersToPdf(this.repository);

  @override
  Future<Either<Failure, String>> call(ExportUsersParams params) async {
    return await repository.exportToPdf(params.users);
  }
}

/// Export Users to Excel Use Case
class ExportUsersToExcel implements UseCase<String, ExportUsersParams> {
  final UserRepository repository;

  ExportUsersToExcel(this.repository);

  @override
  Future<Either<Failure, String>> call(ExportUsersParams params) async {
    return await repository.exportToExcel(params.users);
  }
}

/// Filter Parameters for Users
class UserFilterParams {
  final String? userType;
  final String? userStatus;

  const UserFilterParams({this.userType, this.userStatus});
}

/// Export Parameters for Users
class ExportUsersParams {
  final List<User> users;

  const ExportUsersParams({required this.users});
}

import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, List<User>>> getUsersWithFilters({
    String? userType,
    String? userStatus,
  });
  List<String> getUserTypes();
  List<String> getUserStatuses();
  Future<Either<Failure, String>> exportToPdf(List<User> users);
  Future<Either<Failure, String>> exportToExcel(List<User> users);
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols(String? exchange);
  Future<Either<Failure, List<User>>> getNestedUsers(String parentUserId);
}
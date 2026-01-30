import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';


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
}

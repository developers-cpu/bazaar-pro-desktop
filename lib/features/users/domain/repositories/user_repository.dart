import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for Users
abstract class UserRepository {
  /// Get all users
  Future<Either<Failure, List<User>>> getUsers();

  /// Get users with filters
  Future<Either<Failure, List<User>>> getUsersWithFilters({
    String? userType,
    String? userStatus,
  });

  /// Get available user types for filter dropdown
  List<String> getUserTypes();

  /// Get available user statuses for filter dropdown
  List<String> getUserStatuses();

  /// Export users to PDF
  Future<Either<Failure, String>> exportToPdf(List<User> users);

  /// Export users to Excel
  Future<Either<Failure, String>> exportToExcel(List<User> users);
}

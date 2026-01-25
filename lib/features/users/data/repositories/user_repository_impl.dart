import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsersWithFilters({
    String? userType,
    String? userStatus,
  }) async {
    try {
      final users = await remoteDataSource.getUsersWithFilters(
        userType: userType,
        userStatus: userStatus,
      );
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  List<String> getUserTypes() {
    return ['Master', 'Client'];
  }

  @override
  List<String> getUserStatuses() {
    return ['Active', 'In-Active'];
  }

  @override
  Future<Either<Failure, String>> exportToPdf(List<User> users) async {
    try {
      // TODO: Implement actual PDF export using pdf package
      await Future.delayed(const Duration(seconds: 1));
      final filePath =
          '/downloads/users_${DateTime.now().millisecondsSinceEpoch}.pdf';
      return Right(filePath);
    } catch (e) {
      return Left(ExportFailure('Failed to export PDF: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(List<User> users) async {
    try {
      // TODO: Implement actual Excel export using excel package
      await Future.delayed(const Duration(seconds: 1));
      final filePath =
          '/downloads/users_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      return Right(filePath);
    } catch (e) {
      return Left(ExportFailure('Failed to export Excel: $e'));
    }
  }
}

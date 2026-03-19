import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../domain/entities/users_bill_summary/users_bill_summary_entity.dart';
import '../../../domain/repositories/users_bill_summary/users_bill_summary_repository.dart';
import '../../datasources/users_bill_summary/users_bill_summary_remote_data_source.dart';

class UsersBillSummaryRepositoryImpl implements UsersBillSummaryRepository {
  final UsersBillSummaryRemoteDataSource remoteDataSource;
  UsersBillSummaryRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<UsersBillSummaryEntity>>> getBillSummary(
    String userId,
  ) async {
    try {
      final models = await remoteDataSource.getBillSummary(userId);
      return Right(models);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
import 'package:bazarpro/features/users/data/datasources/user_credit_transaction/user_credit_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_credit_transaction/user_credit_transaction.dart';
import '../../../domain/repositories/user_credit_transaction/user_credit_repository.dart';
class UserCreditRepositoryImpl implements UserCreditRepository {
  final UserCreditDataSource dataSource;
  UserCreditRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserCreditTransaction>>> getUserCreditHistory(
    String userId,
  ) async {
    try {
      final result = await dataSource.getUserCreditHistory(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

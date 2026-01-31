import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_credit_transaction/user_credit_transaction.dart';
import 'package:bazarpro/features/users/domain/repositories/user_credit_transaction/user_credit_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserCredit {
  final UserCreditRepository repository;

  GetUserCredit(this.repository);

  Future<Either<Failure, List<UserCreditTransaction>>> call(
    String userId,
  ) async {
    return await repository.getUserCreditHistory(userId);
  }
}

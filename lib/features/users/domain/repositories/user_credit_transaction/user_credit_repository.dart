import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_credit_transaction/user_credit_transaction.dart';
import 'package:dartz/dartz.dart';
abstract class UserCreditRepository {
  Future<Either<Failure, List<UserCreditTransaction>>> getUserCreditHistory(
    String userId,
  );
}

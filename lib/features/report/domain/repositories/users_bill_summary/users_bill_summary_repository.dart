import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/users_bill_summary/users_bill_summary_entity.dart';

abstract class UsersBillSummaryRepository {
  Future<Either<Failure, List<UsersBillSummaryEntity>>> getBillSummary(
    String userId,
  );
  Future<Either<Failure, List<String>>> getUsers();
}
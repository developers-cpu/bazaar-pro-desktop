import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/users_bill_summary/users_bill_summary_entity.dart';
import '../../repositories/users_bill_summary/users_bill_summary_repository.dart';

class GetBillSummaryData {
  final UsersBillSummaryRepository repository;

  GetBillSummaryData(this.repository);

  Future<Either<Failure, List<UsersBillSummaryEntity>>> call(
    String userId,
  ) async {
    return await repository.getBillSummary(userId);
  }
}

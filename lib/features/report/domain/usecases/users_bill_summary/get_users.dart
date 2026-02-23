import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../repositories/users_bill_summary/users_bill_summary_repository.dart';

class GetUsers {
  final UsersBillSummaryRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getUsers();
  }
}

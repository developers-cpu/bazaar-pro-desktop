import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetExchanges {
  final UserRepository repository;
  GetExchanges(this.repository);
  Future<Either<Failure, List<String>>> call() async {
    return await repository.getExchanges();
  }
}

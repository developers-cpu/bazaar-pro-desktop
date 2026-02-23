import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart'
    show UserRepository;
import 'package:dartz/dartz.dart';

class GetSymbols {
  final UserRepository repository;
  GetSymbols(this.repository);
  Future<Either<Failure, List<String>>> call({String? exchange}) async {
    return await repository.getSymbols(exchange);
  }
}

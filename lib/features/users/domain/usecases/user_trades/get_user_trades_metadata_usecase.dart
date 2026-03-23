import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/entities/user_trades/user_trades_metadata.dart';
import 'package:bazarpro/features/users/domain/repositories/user_trades/user_trades_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserTradesMetadata implements UseCase<UserTradesMetadata, NoParams> {
  final UserTradesRepository repository;
  GetUserTradesMetadata(this.repository);
  @override
  Future<Either<Failure, UserTradesMetadata>> call(NoParams params) async {
    return await repository.getUserTradesMetadata();
  }
}

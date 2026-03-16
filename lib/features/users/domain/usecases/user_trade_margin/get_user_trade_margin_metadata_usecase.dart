import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/entities/user_trade_margin/user_trade_margin_metadata.dart';
import 'package:bazarpro/features/users/domain/repositories/user_trade_margin/user_trade_margin_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserTradeMarginMetadata
    implements UseCase<UserTradeMarginMetadata, NoParams> {
  final UserTradeMarginRepository repository;
  GetUserTradeMarginMetadata(this.repository);
  @override
  Future<Either<Failure, UserTradeMarginMetadata>> call(NoParams params) {
    return repository.getTradeMarginMetadata();
  }
}

import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_trade_margin/user_trade_margin.dart';
import 'package:bazarpro/features/users/domain/repositories/user_trade_margin/user_trade_margin_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserTradeMargin {
  final UserTradeMarginRepository repository;
  GetUserTradeMargin(this.repository);
  Future<Either<Failure, List<UserTradeMargin>>> call(String userId) {
    return repository.getUserTradeMargin(userId);
  }
}
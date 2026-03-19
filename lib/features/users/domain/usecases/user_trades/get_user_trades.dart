import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_trades/user_trade.dart';
import 'package:bazarpro/features/users/domain/repositories/user_trades/user_trades_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserTrades {
  final UserTradesRepository repository;
  GetUserTrades(this.repository);
  Future<Either<Failure, List<UserTrade>>> call(String userId) async {
    return await repository.getUserTrades(userId);
  }
}
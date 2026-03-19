import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_trades/user_trade.dart';
import 'package:bazarpro/features/users/domain/entities/user_trades/user_trades_metadata.dart';
import 'package:dartz/dartz.dart';

abstract class UserTradesRepository {
  Future<Either<Failure, List<UserTrade>>> getUserTrades(String userId);
  Future<Either<Failure, UserTradesMetadata>> getUserTradesMetadata();
}
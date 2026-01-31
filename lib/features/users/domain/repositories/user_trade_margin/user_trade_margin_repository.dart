import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_trade_margin/user_trade_margin.dart';
import 'package:bazarpro/features/users/domain/entities/user_trade_margin/user_trade_margin_metadata.dart';
import 'package:dartz/dartz.dart';

abstract class UserTradeMarginRepository {
  Future<Either<Failure, List<UserTradeMargin>>> getUserTradeMargin(
    String userId,
  );
  Future<Either<Failure, UserTradeMarginMetadata>> getTradeMarginMetadata();
}

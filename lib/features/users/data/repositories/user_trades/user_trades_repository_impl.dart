import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_trades/user_trade.dart';
import '../../../domain/entities/user_trades/user_trades_metadata.dart';
import '../../../domain/repositories/user_trades/user_trades_repository.dart';
import '../../datasources/user_trades/user_trades_datasource.dart';

class UserTradesRepositoryImpl implements UserTradesRepository {
  final UserTradesDataSource dataSource;
  UserTradesRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserTrade>>> getUserTrades(String userId) async {
    try {
      final models = await dataSource.getUserTrades(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserTradesMetadata>> getUserTradesMetadata() async {
    try {
      final metadata = await dataSource.getUserTradesMetadata();
      return Right(metadata);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
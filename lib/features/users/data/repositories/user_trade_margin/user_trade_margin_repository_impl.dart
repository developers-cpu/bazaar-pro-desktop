import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_trade_margin/user_trade_margin.dart';
import '../../../domain/entities/user_trade_margin/user_trade_margin_metadata.dart';
import '../../../domain/repositories/user_trade_margin/user_trade_margin_repository.dart';
import '../../datasources/user_trade_margin/user_trade_margin_datasource.dart';
class UserTradeMarginRepositoryImpl implements UserTradeMarginRepository {
  final UserTradeMarginDataSource dataSource;
  UserTradeMarginRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserTradeMargin>>> getUserTradeMargin(
    String userId,
  ) async {
    try {
      final models = await dataSource.getUserTradeMargin(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, UserTradeMarginMetadata>>
  getTradeMarginMetadata() async {
    try {
      final model = await dataSource.getTradeMarginMetadata();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

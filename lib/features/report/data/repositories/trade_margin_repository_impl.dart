import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/trade_margin.dart';
import '../../domain/repositories/trade_margin_repository.dart';
import '../datasources/trade_margin/trade_margin_remote_datasource.dart';

class TradeMarginRepositoryImpl implements TradeMarginRepository {
  final TradeMarginRemoteDataSource remoteDataSource;

  TradeMarginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TradeMargin>>> getTradeMargins({
    String? exchange,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getTradeMargins(
        exchange: exchange,
        search: search,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

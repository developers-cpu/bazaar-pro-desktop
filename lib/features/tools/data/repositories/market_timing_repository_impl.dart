import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/market_timing_entity.dart';
import '../../domain/repositories/market_timing_repository.dart';
import '../datasources/market_timing_remote_datasource.dart';
class MarketTimingRepositoryImpl implements MarketTimingRepository {
  final MarketTimingRemoteDataSource remoteDataSource;
  MarketTimingRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, MarketTimingEntity>> getMarketTiming(
    String exchange,
    DateTime date,
  ) async {
    try {
      final result = await remoteDataSource.getMarketTiming(exchange, date);
      return Right(result);
    } catch (e) {
      return const Left(UnknownFailure('Server error occurred'));
    }
  }
}

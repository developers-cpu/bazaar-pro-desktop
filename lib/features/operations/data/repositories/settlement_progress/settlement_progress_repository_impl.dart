import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/settlement_progress/bhav_copy_entity.dart';
import '../../../domain/repositories/settlement_progress/settlement_progress_repository.dart';
import '../../datasources/settlement_progress/settlement_progress_remote_data_source.dart';
import '../../models/bhav_copy_model.dart';

class SettlementProgressRepositoryImpl implements SettlementProgressRepository {
  final SettlementProgressRemoteDataSource remoteDataSource;

  SettlementProgressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BhavCopyEntity>>> importBhavCopy(
    String filePath,
  ) async {
    try {
      final result = await remoteDataSource.importBhavCopy(filePath);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitBhavCopy(
    List<BhavCopyEntity> data,
  ) async {
    try {
      final models = data
          .map(
            (e) => BhavCopyModel(
              exch: e.exch,
              symbol: e.symbol,
              expiryDate: e.expiryDate,
              dayHigh: e.dayHigh,
              dayLow: e.dayLow,
              dayClose: e.dayClose,
            ),
          )
          .toList();

      await remoteDataSource.submitBhavCopy(models);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BhavCopyEntity>>> getSettlementData(
    String exchange,
  ) async {
    try {
      final result = await remoteDataSource.getSettlementData(exchange);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

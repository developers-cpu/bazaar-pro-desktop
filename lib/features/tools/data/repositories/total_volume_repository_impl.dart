import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/total_volume_entity.dart';
import '../../domain/repositories/total_volume_repository.dart';
import '../datasources/total_volume_remote_datasource.dart';

class TotalVolumeRepositoryImpl implements TotalVolumeRepository {
  final TotalVolumeRemoteDataSource remoteDataSource;
  TotalVolumeRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, TotalVolumeEntity>> getTotalVolume(
    String exchange,
  ) async {
    try {
      final remoteVolume = await remoteDataSource.getTotalVolume(exchange);
      return Right(remoteVolume);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/surveillance/surveillance_data.dart';
import '../../../domain/repositories/surveillance/surveillance_repository.dart';
import '../../datasources/surveillance/surveillance_remote_data_source.dart';
import '../../models/surveillance/surveillance_data_model.dart';
class SurveillanceRepositoryImpl implements SurveillanceRepository {
  final SurveillanceRemoteDataSource remoteDataSource;
  SurveillanceRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, SurveillanceData>> getSurveillanceData() async {
    try {
      final remoteData = await remoteDataSource.getSurveillanceData();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> updateSurveillanceData(
    SurveillanceData data,
  ) async {
    try {
      final model = SurveillanceDataModel.fromEntity(data);
      await remoteDataSource.updateSurveillanceData(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

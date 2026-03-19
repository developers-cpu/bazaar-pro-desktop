import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/total_volume_entity.dart';
import '../repositories/total_volume_repository.dart';

class GetTotalVolumeUseCase implements UseCase<TotalVolumeEntity, String> {
  final TotalVolumeRepository repository;
  GetTotalVolumeUseCase(this.repository);
  @override
  Future<Either<Failure, TotalVolumeEntity>> call(String params) async {
    return await repository.getTotalVolume(params);
  }
}
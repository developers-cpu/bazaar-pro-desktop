import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/total_volume_entity.dart';
abstract class TotalVolumeRepository {
  Future<Either<Failure, TotalVolumeEntity>> getTotalVolume(String exchange);
}

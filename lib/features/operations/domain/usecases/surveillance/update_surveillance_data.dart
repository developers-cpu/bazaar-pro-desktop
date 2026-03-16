import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/surveillance/surveillance_data.dart';
import '../../repositories/surveillance/surveillance_repository.dart';
class UpdateSurveillanceData {
  final SurveillanceRepository repository;
  UpdateSurveillanceData(this.repository);
  Future<Either<Failure, void>> call(SurveillanceData data) async {
    return await repository.updateSurveillanceData(data);
  }
}

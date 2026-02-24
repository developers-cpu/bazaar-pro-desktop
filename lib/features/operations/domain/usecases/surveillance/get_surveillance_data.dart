import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/surveillance/surveillance_data.dart';
import '../../repositories/surveillance/surveillance_repository.dart';

class GetSurveillanceData {
  final SurveillanceRepository repository;
  GetSurveillanceData(this.repository);
  Future<Either<Failure, SurveillanceData>> call() async {
    return await repository.getSurveillanceData();
  }
}

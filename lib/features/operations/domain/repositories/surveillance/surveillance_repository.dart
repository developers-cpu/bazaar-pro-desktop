import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/surveillance/surveillance_data.dart';
abstract class SurveillanceRepository {
  Future<Either<Failure, SurveillanceData>> getSurveillanceData();
  Future<Either<Failure, void>> updateSurveillanceData(SurveillanceData data);
}

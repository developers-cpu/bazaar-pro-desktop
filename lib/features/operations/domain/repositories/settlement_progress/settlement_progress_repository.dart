import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/settlement_progress/bhav_copy_entity.dart';

abstract class SettlementProgressRepository {
  Future<Either<Failure, List<BhavCopyEntity>>> importBhavCopy(String filePath);

  Future<Either<Failure, void>> submitBhavCopy(List<BhavCopyEntity> data);

  Future<Either<Failure, List<BhavCopyEntity>>> getSettlementData(
    String exchange,
  );
}

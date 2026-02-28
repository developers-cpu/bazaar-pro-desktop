import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/settlement_progress/bhav_copy_entity.dart';
import '../../repositories/settlement_progress/settlement_progress_repository.dart';

class GetSettlementDataUseCase
    implements UseCase<List<BhavCopyEntity>, String> {
  final SettlementProgressRepository repository;

  GetSettlementDataUseCase(this.repository);

  @override
  Future<Either<Failure, List<BhavCopyEntity>>> call(String params) async {
    return await repository.getSettlementData(params);
  }
}

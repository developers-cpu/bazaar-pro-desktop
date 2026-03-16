import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/settlement_progress/bhav_copy_entity.dart';
import '../../repositories/settlement_progress/settlement_progress_repository.dart';
class SubmitBhavCopyUseCase implements UseCase<void, List<BhavCopyEntity>> {
  final SettlementProgressRepository repository;
  SubmitBhavCopyUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(List<BhavCopyEntity> params) async {
    return await repository.submitBhavCopy(params);
  }
}

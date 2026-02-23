import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/group.dart';
import '../repositories/operation_repository.dart';

class GetGroups implements UseCase<List<Group>, NoParams> {
  final OperationRepository repository;

  GetGroups(this.repository);

  @override
  Future<Either<Failure, List<Group>>> call(NoParams params) async {
    return await repository.getGroups();
  }
}

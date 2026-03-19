import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/operations/domain/entities/group/group.dart';
import 'package:bazarpro/features/operations/domain/repositories/group/group_repository.dart';
import 'package:dartz/dartz.dart';

class GetGroups implements UseCase<List<Group>, NoParams> {
  final GroupRepository repository;
  GetGroups(this.repository);
  @override
  Future<Either<Failure, List<Group>>> call(NoParams params) async {
    return await repository.getGroups();
  }
}
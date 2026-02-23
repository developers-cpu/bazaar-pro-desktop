import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group.dart';

abstract class OperationRepository {
  Future<Either<Failure, List<Group>>> getGroups();
  Future<Either<Failure, bool>> addGroup({
    required String exchange,
    required String groupName,
    required bool isDefault,
  });
}

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/group/group.dart';

abstract class GroupRepository {
  Future<Either<Failure, List<Group>>> getGroups();
  Future<Either<Failure, bool>> addGroup({
    required String exchange,
    required String groupName,
    required bool isDefault,
  });
}

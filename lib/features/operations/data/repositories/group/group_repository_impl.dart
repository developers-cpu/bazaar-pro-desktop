import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/group/group.dart';
import '../../../domain/repositories/group/group_repository.dart';
import '../../datasources/group/group_remote_data_source.dart';
class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;
  GroupRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<Group>>> getGroups() async {
    try {
      final remoteGroups = await remoteDataSource.getGroups();
      return Right(remoteGroups);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  @override
  Future<Either<Failure, bool>> addGroup({
    required String exchange,
    required String groupName,
    required bool isDefault,
  }) async {
    try {
      final result = await remoteDataSource.addGroup(
        exchange: exchange,
        groupName: groupName,
        isDefault: isDefault,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/my_profile_entity.dart';
import '../../domain/repositories/my_profile_repository.dart';
import '../datasources/my_profile_remote_datasource.dart';

class MyProfileRepositoryImpl implements MyProfileRepository {
  final MyProfileRemoteDataSource remoteDataSource;

  MyProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MyProfileEntity>> getMyProfile() async {
    try {
      final remoteProfile = await remoteDataSource.getMyProfile();
      return Right(remoteProfile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

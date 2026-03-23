import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_sharing_details/user_sharing_details.dart';
import '../../../domain/repositories/user_sharing_details/user_sharing_details_repository.dart';
import '../../datasources/user_sharing_details/user_sharing_details_datasource.dart';

class UserSharingDetailsRepositoryImpl implements UserSharingDetailsRepository {
  final UserSharingDetailsDataSource dataSource;
  UserSharingDetailsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, UserSharingDetails>> getUserSharingDetails(
    String userId,
  ) async {
    try {
      final model = await dataSource.getUserSharingDetails(userId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

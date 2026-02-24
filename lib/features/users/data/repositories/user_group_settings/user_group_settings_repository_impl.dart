import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_group_settings/user_group_settings.dart';
import '../../../domain/repositories/user_group_settings/user_group_settings_repository.dart';
import '../../datasources/user_group_settings/user_group_settings_datasource.dart';

class UserGroupSettingsRepositoryImpl implements UserGroupSettingsRepository {
  final UserGroupSettingsDataSource dataSource;
  UserGroupSettingsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<UserGroupSettings>>> getUserGroupSettings(
    String userId,
  ) async {
    try {
      final result = await dataSource.getUserGroupSettings(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_group_settings/user_group_settings.dart';
import 'package:dartz/dartz.dart';

abstract class UserGroupSettingsRepository {
  Future<Either<Failure, List<UserGroupSettings>>> getUserGroupSettings(
    String userId,
  );
}
import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../entities/user_group_settings/user_group_settings.dart';
import '../../repositories/user_group_settings/user_group_settings_repository.dart';

class GetUserGroupSettings {
  final UserGroupSettingsRepository repository;
  GetUserGroupSettings(this.repository);
  Future<Either<Failure, List<UserGroupSettings>>> call(String userId) async {
    return await repository.getUserGroupSettings(userId);
  }
}
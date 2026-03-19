import 'package:bazarpro/features/users/domain/entities/user_brokerage_setting/user_brokerage_setting.dart';
import 'package:bazarpro/features/users/domain/repositories/user_brokerage_setting/user_brokerage_setting_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/usecases/usecase.dart';

class GetUserBrokerageSettings
    implements UseCase<List<UserBrokerageSetting>, String> {
  final UserBrokerageSettingRepository repository;
  GetUserBrokerageSettings(this.repository);
  @override
  Future<Either<Failure, List<UserBrokerageSetting>>> call(
    String userId,
  ) async {
    return await repository.getUserBrokerageSettings(userId);
  }
}
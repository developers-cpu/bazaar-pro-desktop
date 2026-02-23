import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_brokerage_setting/user_brokerage_setting.dart';
import 'package:dartz/dartz.dart';
abstract class UserBrokerageSettingRepository {
  Future<Either<Failure, List<UserBrokerageSetting>>> getUserBrokerageSettings(
    String userId,
  );
  Future<Either<Failure, void>> updateBrokerageSettings({
    required List<String> selectedIds,
    double? turnoverWiseBrk,
    double? symbolWiseBrk,
  });
}

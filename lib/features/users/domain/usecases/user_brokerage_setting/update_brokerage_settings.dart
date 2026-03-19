import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/repositories/user_brokerage_setting/user_brokerage_setting_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateBrokerageSettings {
  final UserBrokerageSettingRepository repository;
  UpdateBrokerageSettings(this.repository);
  Future<Either<Failure, void>> call({
    required List<String> selectedIds,
    double? turnoverWiseBrk,
    double? symbolWiseBrk,
  }) async {
    return await repository.updateBrokerageSettings(
      selectedIds: selectedIds,
      turnoverWiseBrk: turnoverWiseBrk,
      symbolWiseBrk: symbolWiseBrk,
    );
  }
}
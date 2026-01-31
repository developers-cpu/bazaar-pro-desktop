import 'package:bazarpro/features/users/data/datasources/user_brokerage_setting/user_brokerage_setting_datasource.dart'
    show UserBrokerageSettingDataSource;
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user_brokerage_setting/user_brokerage_setting.dart';
import '../../../domain/repositories/user_brokerage_setting/user_brokerage_setting_repository.dart';

class UserBrokerageSettingRepositoryImpl
    implements UserBrokerageSettingRepository {
  final UserBrokerageSettingDataSource dataSource;

  UserBrokerageSettingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<UserBrokerageSetting>>> getUserBrokerageSettings(
    String userId,
  ) async {
    try {
      final settings = await dataSource.getUserBrokerageSettings(userId);
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBrokerageSettings({
    required List<String> selectedIds,
    double? turnoverWiseBrk,
    double? symbolWiseBrk,
  }) async {
    try {
      await dataSource.updateBrokerageSettings(
        selectedIds: selectedIds,
        turnoverWiseBrk: turnoverWiseBrk,
        symbolWiseBrk: symbolWiseBrk,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:bazarpro/features/users/data/models/user_brokerage_setting/user_brokerage_setting_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserBrokerageSettingDataSource {
  Future<List<UserBrokerageSettingModel>> getUserBrokerageSettings(
    String userId,
  );
  Future<void> updateBrokerageSettings({
    required List<String> selectedIds,
    double? turnoverWiseBrk,
    double? symbolWiseBrk,
  });
}

class UserBrokerageSettingDataSourceImpl
    implements UserBrokerageSettingDataSource {
  @override
  Future<List<UserBrokerageSettingModel>> getUserBrokerageSettings(
    String userId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserBrokerageSettingModel(
        id: '1',
        exchange: 'NSE',
        symbol: null,
        turnoverWiseBrk: 100.0,
        symbolWiseBrk: 0.0,
        brokerageType: 'Exchange',
      ),
      const UserBrokerageSettingModel(
        id: '2',
        exchange: 'MCX',
        symbol: 'GOLD',
        turnoverWiseBrk: 0.0,
        symbolWiseBrk: 50.0,
        brokerageType: 'Symbol',
      ),
    ];
  }

  @override
  Future<void> updateBrokerageSettings({
    required List<String> selectedIds,
    double? turnoverWiseBrk,
    double? symbolWiseBrk,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
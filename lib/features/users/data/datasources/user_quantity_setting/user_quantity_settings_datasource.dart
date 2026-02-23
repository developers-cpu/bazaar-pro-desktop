import 'package:bazarpro/features/users/data/models/user_quantity_setting/user_quantity_setting_metadata_model.dart';
import 'package:bazarpro/features/users/data/models/user_quantity_setting/user_quantity_setting_model.dart';
abstract class UserQuantitySettingsDataSource {
  Future<List<UserQuantitySettingModel>> getUserQuantitySettings(String userId);
  Future<UserQuantitySettingMetadataModel> getQuantitySettingsMetadata();
}
class UserQuantitySettingsDataSourceImpl
    implements UserQuantitySettingsDataSource {
  @override
  Future<List<UserQuantitySettingModel>> getUserQuantitySettings(
    String userId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserQuantitySettingModel(
        id: '1',
        symbol: 'SGX GIFTNIFTY Oct 28',
        maxQty: 100,
        breakupQty: 50,
        maxLot: 10,
        breakupLot: 5,
      ),
      const UserQuantitySettingModel(
        id: '2',
        symbol: 'NSE NIFTY Oct 28',
        maxQty: 200,
        breakupQty: 100,
        maxLot: 20,
        breakupLot: 10,
      ),
    ];
  }
  @override
  Future<UserQuantitySettingMetadataModel> getQuantitySettingsMetadata() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserQuantitySettingMetadataModel.mock();
  }
}

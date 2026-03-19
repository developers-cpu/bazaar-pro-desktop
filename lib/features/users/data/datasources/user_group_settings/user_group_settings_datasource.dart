import 'package:bazarpro/features/users/data/models/user_group_settings/user_group_settings_model.dart';

abstract class UserGroupSettingsDataSource {
  Future<List<UserGroupSettingsModel>> getUserGroupSettings(String userId);
}

class UserGroupSettingsDataSourceImpl implements UserGroupSettingsDataSource {
  @override
  Future<List<UserGroupSettingsModel>> getUserGroupSettings(
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const UserGroupSettingsModel(
        id: '1',
        groupName: 'GOLD',
        isAllowed: true,
        maxQuantity: 100.0,
      ),
      const UserGroupSettingsModel(
        id: '2',
        groupName: 'SILVER',
        isAllowed: false,
        maxQuantity: 50.0,
      ),
      const UserGroupSettingsModel(
        id: '3',
        groupName: 'CRUDEOIL',
        isAllowed: true,
        maxQuantity: 200.0,
      ),
    ];
  }
}
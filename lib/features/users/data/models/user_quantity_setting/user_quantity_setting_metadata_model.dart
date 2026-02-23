import '../../../domain/entities/user_quantity_setting/user_quantity_setting_metadata.dart';
class UserQuantitySettingMetadataModel extends UserQuantitySettingMetadata {
  const UserQuantitySettingMetadataModel({required super.symbols});
  factory UserQuantitySettingMetadataModel.mock() {
    return const UserQuantitySettingMetadataModel(
      symbols: [
        'SGX GIFTNIFTY Oct 28',
        'NSE NIFTY Oct 28',
        'NSE BANKNIFTY Oct 28',
      ],
    );
  }
}

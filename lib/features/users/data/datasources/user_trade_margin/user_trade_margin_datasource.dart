import 'package:bazarpro/features/users/data/models/user_trade_margin/user_trade_margin_metadata_model.dart';
import 'package:bazarpro/features/users/data/models/user_trade_margin/user_trade_margin_model.dart';
abstract class UserTradeMarginDataSource {
  Future<List<UserTradeMarginModel>> getUserTradeMargin(String userId);
  Future<UserTradeMarginMetadataModel> getTradeMarginMetadata();
}
class UserTradeMarginDataSourceImpl implements UserTradeMarginDataSource {
  @override
  Future<List<UserTradeMarginModel>> getUserTradeMargin(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      UserTradeMarginModel(
        id: '1',
        exchange: 'NSE',
        symbol: 'NIFTY',
        expiryDate: DateTime(2023, 10, 26),
        marginPercentage: 20,
        marginAmount: 150000,
        isSelected: false,
      ),
      UserTradeMarginModel(
        id: '2',
        exchange: 'MCX',
        symbol: 'CRUDEOIL',
        expiryDate: DateTime(2023, 11, 15),
        marginPercentage: 15,
        marginAmount: 85000,
        isSelected: false,
      ),
    ];
  }
  @override
  Future<UserTradeMarginMetadataModel> getTradeMarginMetadata() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserTradeMarginMetadataModel.mock();
  }
}

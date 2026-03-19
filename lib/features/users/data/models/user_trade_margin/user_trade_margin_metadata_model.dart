import '../../../domain/entities/user_trade_margin/user_trade_margin_metadata.dart';

class UserTradeMarginMetadataModel extends UserTradeMarginMetadata {
  const UserTradeMarginMetadataModel({
    required super.exchanges,
    required super.symbols,
  });
  factory UserTradeMarginMetadataModel.mock() {
    return const UserTradeMarginMetadataModel(
      exchanges: ['NSE', 'MCX'],
      symbols: [
        'SGX GIFTNIFTY Oct 28',
        'NSE NIFTY Oct 28',
        'NSE BANKNIFTY Oct 28',
        'CRUDEOIL Nov 15',
      ],
    );
  }
}
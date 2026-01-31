import '../../../domain/entities/user_pending_order/user_pending_order_metadata.dart';

class UserPendingOrderMetadataModel extends UserPendingOrderMetadata {
  const UserPendingOrderMetadataModel({
    required super.exchanges,
    required super.symbols,
    required super.orderTypes,
  });

  factory UserPendingOrderMetadataModel.mock() {
    return const UserPendingOrderMetadataModel(
      exchanges: ['NSE', 'MCX'],
      symbols: [
        'SGX GIFTNIFTY Oct 28',
        'NSE NIFTY Oct 28',
        'NSE BANKNIFTY Oct 28',
      ],
      orderTypes: ['All', 'Buy Limit', 'Buy Stop', 'Sell Limit', 'Sell Stop'],
    );
  }
}

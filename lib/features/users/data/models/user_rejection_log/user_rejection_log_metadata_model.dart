import '../../../domain/entities/user_rejection_log/user_rejection_log_metadata.dart';

class UserRejectionLogMetadataModel extends UserRejectionLogMetadata {
  const UserRejectionLogMetadataModel({
    required super.exchanges,
    required super.symbols,
  });
  factory UserRejectionLogMetadataModel.mock() {
    return const UserRejectionLogMetadataModel(
      exchanges: ['NSE', 'MCX', 'BSE'],
      symbols: [
        'SGX GIFTNIFTY Oct 28',
        'NSE NIFTY Oct 28',
        'NSE BANKNIFTY Oct 28',
        'CRUDEOIL Nov 15',
      ],
    );
  }
}
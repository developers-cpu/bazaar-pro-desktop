import '../../models/bhav_copy_model.dart';
import 'settlement_progress_remote_data_source.dart';

class SettlementProgressRemoteDataSourceImpl
    implements SettlementProgressRemoteDataSource {
  @override
  Future<List<BhavCopyModel>> importBhavCopy(String filePath) async {
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(
      15,
      (index) => BhavCopyModel(
        exch: 'MCX',
        symbol: 'SYMBOL_$index',
        expiryDate: '26/12/26',
        dayHigh: 10000000.0,
        dayLow: 10000000.0,
        dayClose: 10000000.0,
      ),
    );
  }

  @override
  Future<void> submitBhavCopy(List<BhavCopyModel> data) async {
    await Future.delayed(const Duration(seconds: 3));
    return;
  }

  @override
  Future<List<BhavCopyModel>> getSettlementData(String exchange) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return List.generate(
      20,
      (index) => BhavCopyModel(
        exch: exchange.toUpperCase(),
        symbol: '${exchange.toUpperCase()}_STK_$index',
        expiryDate: '26/12/26',
        dayHigh: 10000000.0,
        dayLow: 10000000.0,
        dayClose: 10000000.0,
      ),
    );
  }
}

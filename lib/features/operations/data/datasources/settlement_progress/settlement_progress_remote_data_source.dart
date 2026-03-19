import '../../models/bhav_copy_model.dart';

abstract class SettlementProgressRemoteDataSource {
  Future<List<BhavCopyModel>> importBhavCopy(String filePath);
  Future<void> submitBhavCopy(List<BhavCopyModel> data);
  Future<List<BhavCopyModel>> getSettlementData(String exchange);
}
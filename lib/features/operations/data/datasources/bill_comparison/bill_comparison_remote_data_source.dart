import '../../models/bill_comparison/bill_comparison_model.dart';
abstract class BillComparisonRemoteDataSource {
  Future<List<BillComparisonModel>> getBillComparisonData({
    required String startDate,
    required String endDate,
  });
}

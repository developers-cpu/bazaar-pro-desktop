import '../../entities/bill_comparison/bill_comparison_entity.dart';
abstract class BillComparisonRepository {
  Future<List<BillComparisonEntity>> getBillComparisonData({
    required String startDate,
    required String endDate,
  });
}

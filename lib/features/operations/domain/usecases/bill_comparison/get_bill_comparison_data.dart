import '../../entities/bill_comparison/bill_comparison_entity.dart';
import '../../repositories/bill_comparison/bill_comparison_repository.dart';

class GetBillComparisonData {
  final BillComparisonRepository repository;
  GetBillComparisonData(this.repository);
  Future<List<BillComparisonEntity>> call({
    required String startDate,
    required String endDate,
  }) async {
    return await repository.getBillComparisonData(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
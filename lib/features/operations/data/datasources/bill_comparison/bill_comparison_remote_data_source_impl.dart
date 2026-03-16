import '../../models/bill_comparison/bill_comparison_model.dart';
import 'bill_comparison_remote_data_source.dart';

class BillComparisonRemoteDataSourceImpl
    implements BillComparisonRemoteDataSource {
  @override
  Future<List<BillComparisonModel>> getBillComparisonData({
    required String startDate,
    required String endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      const BillComparisonModel(
        index: 1,
        username: 'Demo',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '5500',
        type: 'ALL Good',
      ),
      const BillComparisonModel(
        index: 2,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '5500',
        type: 'ALL Good',
      ),
      const BillComparisonModel(
        index: 3,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '4500',
        type: 'Mistmatch',
      ),
      const BillComparisonModel(
        index: 4,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '5500',
        type: 'ALL Good',
      ),
      const BillComparisonModel(
        index: 5,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '250000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '5500',
        type: 'Mistmatch',
      ),
      const BillComparisonModel(
        index: 6,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '500',
        settlementNetTotal: '5500',
        type: 'Mistmatch',
      ),
      const BillComparisonModel(
        index: 7,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '5500',
        type: 'ALL Good',
      ),
      const BillComparisonModel(
        index: 8,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '5500',
        type: 'ALL Good',
      ),
      const BillComparisonModel(
        index: 10,
        username: 'Demo 01',
        billTotal: '350000000',
        billBrokerage: '5500',
        billNetTotal: '5500',
        settlementTotal: '350000000',
        settlementBrokerage: '5500',
        settlementNetTotal: '200',
        type: 'Mistmatch',
      ),
    ];
  }
}

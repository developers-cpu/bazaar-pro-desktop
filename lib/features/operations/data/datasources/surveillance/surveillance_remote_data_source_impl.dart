import '../../models/surveillance/surveillance_data_model.dart';
import '../../models/surveillance/surveillance_bulk_order_model.dart';
import '../../models/surveillance/surveillance_vpn_model.dart';
import 'surveillance_remote_data_source.dart';

class SurveillanceRemoteDataSourceImpl implements SurveillanceRemoteDataSource {
  SurveillanceDataModel _mockData = SurveillanceDataModel(
    bulkOrders: [
      SurveillanceBulkOrderModel(
        id: '1',
        exchange: 'MCX',
        symbol: 'ABB25DECFUT',
        intervalTime: 10,
        totalQuantity: 500,
        tradeSlLimit: 5,
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
      ),
      SurveillanceBulkOrderModel(
        id: '2',
        exchange: 'MCX',
        symbol: 'ABCAPITAL25DECFUT',
        intervalTime: 10,
        totalQuantity: 500,
        tradeSlLimit: 5,
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
      ),
      SurveillanceBulkOrderModel(
        id: '3',
        exchange: 'MCX',
        symbol: 'ADANIENSOL25DECFUT',
        intervalTime: 10,
        totalQuantity: 500,
        tradeSlLimit: 5,
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
      ),
      SurveillanceBulkOrderModel(
        id: '4',
        exchange: 'MCX',
        symbol: '360ONE25DECFUT',
        intervalTime: 10,
        totalQuantity: 500,
        tradeSlLimit: 5,
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
      ),
      SurveillanceBulkOrderModel(
        id: '5',
        exchange: 'MCX',
        symbol: 'BAJAJ-AUTO25DECFUT',
        intervalTime: 10,
        totalQuantity: 500,
        tradeSlLimit: 5,
        updatedOn: '26/12/25 | 12:00:00 AM',
        updatedBy: 'DEMO4',
      ),
    ],
    vpnRestriction: SurveillanceVpnModel(
      masterRestriction: true,
      clientRestriction: true,
    ),
  );
  @override
  Future<SurveillanceDataModel> getSurveillanceData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData;
  }

  @override
  Future<void> updateSurveillanceData(SurveillanceDataModel data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockData = data;
  }
}
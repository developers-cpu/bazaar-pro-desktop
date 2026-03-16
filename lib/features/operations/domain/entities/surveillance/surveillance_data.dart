import 'surveillance_bulk_order.dart';
import 'surveillance_vpn.dart';
class SurveillanceData {
  final List<SurveillanceBulkOrder> bulkOrders;
  final SurveillanceVpn vpnRestriction;
  const SurveillanceData({
    required this.bulkOrders,
    required this.vpnRestriction,
  });
  SurveillanceData copyWith({
    List<SurveillanceBulkOrder>? bulkOrders,
    SurveillanceVpn? vpnRestriction,
  }) {
    return SurveillanceData(
      bulkOrders: bulkOrders ?? this.bulkOrders,
      vpnRestriction: vpnRestriction ?? this.vpnRestriction,
    );
  }
}

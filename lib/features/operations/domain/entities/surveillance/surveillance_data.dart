import 'surveillance_bulk_order.dart';
import 'surveillance_vpn.dart';

class SurveillanceData {
  final List<SurveillanceBulkOrder> bulkOrders;
  final SurveillanceVpn vpnRestriction;
  final List<String> spotIndexSymbols;
  const SurveillanceData({
    required this.bulkOrders,
    required this.vpnRestriction,
    required this.spotIndexSymbols,
  });
  SurveillanceData copyWith({
    List<SurveillanceBulkOrder>? bulkOrders,
    SurveillanceVpn? vpnRestriction,
    List<String>? spotIndexSymbols,
  }) {
    return SurveillanceData(
      bulkOrders: bulkOrders ?? this.bulkOrders,
      vpnRestriction: vpnRestriction ?? this.vpnRestriction,
      spotIndexSymbols: spotIndexSymbols ?? this.spotIndexSymbols,
    );
  }
}

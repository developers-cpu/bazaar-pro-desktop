import '../../../domain/entities/surveillance/surveillance_data.dart';
import 'surveillance_bulk_order_model.dart';
import 'surveillance_vpn_model.dart';

class SurveillanceDataModel extends SurveillanceData {
  const SurveillanceDataModel({
    required super.bulkOrders,
    required super.vpnRestriction,
  });
  factory SurveillanceDataModel.fromJson(Map<String, dynamic> json) {
    return SurveillanceDataModel(
      bulkOrders:
          (json['bulkOrders'] as List?)
              ?.map((e) => SurveillanceBulkOrderModel.fromJson(e))
              .toList() ??
          [],
      vpnRestriction: SurveillanceVpnModel.fromJson(
        json['vpnRestriction'] ?? {},
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'bulkOrders': bulkOrders
          .map((e) => (e as SurveillanceBulkOrderModel).toJson())
          .toList(),
      'vpnRestriction': (vpnRestriction as SurveillanceVpnModel).toJson(),
    };
  }

  factory SurveillanceDataModel.fromEntity(SurveillanceData entity) {
    return SurveillanceDataModel(
      bulkOrders: entity.bulkOrders
          .map((e) => SurveillanceBulkOrderModel.fromEntity(e))
          .toList(),
      vpnRestriction: SurveillanceVpnModel.fromEntity(entity.vpnRestriction),
    );
  }
}
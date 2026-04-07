import '../../../domain/entities/surveillance/surveillance_data.dart';
import 'surveillance_bulk_order_model.dart';
import 'surveillance_vpn_model.dart';

class SurveillanceDataModel extends SurveillanceData {
  const SurveillanceDataModel({
    required super.bulkOrders,
    required super.vpnRestriction,
    required super.spotIndexSymbols,
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
      spotIndexSymbols:
          (json['spotIndexSymbols'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'bulkOrders': bulkOrders
          .map((e) => (e as SurveillanceBulkOrderModel).toJson())
          .toList(),
      'vpnRestriction': (vpnRestriction as SurveillanceVpnModel).toJson(),
      'spotIndexSymbols': spotIndexSymbols,
    };
  }

  factory SurveillanceDataModel.fromEntity(SurveillanceData entity) {
    return SurveillanceDataModel(
      bulkOrders: entity.bulkOrders
          .map((e) => SurveillanceBulkOrderModel.fromEntity(e))
          .toList(),
      vpnRestriction: SurveillanceVpnModel.fromEntity(entity.vpnRestriction),
      spotIndexSymbols: entity.spotIndexSymbols,
    );
  }
}

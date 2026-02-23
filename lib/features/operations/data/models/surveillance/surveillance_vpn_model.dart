import '../../../domain/entities/surveillance/surveillance_vpn.dart';
class SurveillanceVpnModel extends SurveillanceVpn {
  const SurveillanceVpnModel({
    required super.masterRestriction,
    required super.clientRestriction,
  });
  factory SurveillanceVpnModel.fromJson(Map<String, dynamic> json) {
    return SurveillanceVpnModel(
      masterRestriction: json['masterRestriction'] ?? true,
      clientRestriction: json['clientRestriction'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'masterRestriction': masterRestriction,
      'clientRestriction': clientRestriction,
    };
  }
  factory SurveillanceVpnModel.fromEntity(SurveillanceVpn entity) {
    return SurveillanceVpnModel(
      masterRestriction: entity.masterRestriction,
      clientRestriction: entity.clientRestriction,
    );
  }
}

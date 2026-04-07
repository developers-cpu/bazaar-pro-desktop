import 'package:flutter/material.dart';
import '../../../../domain/entities/surveillance/surveillance_vpn.dart';
import '../vpn_restriction_view.dart';

class VpnRestrictionTab extends StatelessWidget {
  final SurveillanceVpn vpnData;

  const VpnRestrictionTab({super.key, required this.vpnData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: VpnRestrictionView(vpnData: vpnData));
  }
}

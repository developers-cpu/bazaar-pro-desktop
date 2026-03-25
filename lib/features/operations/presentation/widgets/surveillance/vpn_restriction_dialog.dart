import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/surveillance/surveillance_vpn.dart';
import '../../bloc/surveillance/surveillance_bloc.dart';
import '../../bloc/surveillance/surveillance_event.dart';
import '../../bloc/surveillance/surveillance_state.dart';
import 'vpn_restriction_view.dart';

class VpnRestrictionDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'VPN Restriction',
      width: 300.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(15.w),
      contentBuilder: (ctx, onClose) => BlocProvider(
        create: (_) => sl<SurveillanceBloc>()..add(LoadSurveillanceDataEvent()),
        child: const _VpnRestrictionDialogContent(),
      ),
    );
  }
}

class _VpnRestrictionDialogContent extends StatefulWidget {
  const _VpnRestrictionDialogContent();

  @override
  State<_VpnRestrictionDialogContent> createState() =>
      _VpnRestrictionDialogContentState();
}

class _VpnRestrictionDialogContentState
    extends State<_VpnRestrictionDialogContent> {
  SurveillanceVpn? _cachedVpn;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SurveillanceBloc, SurveillanceState>(
      listener: (context, state) {
        if (state is SurveillanceLoaded) {
          setState(() => _cachedVpn = state.data.vpnRestriction);
        } else if (state is SurveillanceUpdateSuccess) {
          setState(() => _cachedVpn = state.data.vpnRestriction);
        } else if (state is SurveillanceError && state.currentData != null) {
          setState(() => _cachedVpn = state.currentData!.vpnRestriction);
        }

        if (state is SurveillanceUpdateSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is SurveillanceError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final vpnData = switch (state) {
          SurveillanceLoaded(:final data) => data.vpnRestriction,
          SurveillanceUpdateSuccess(:final data) => data.vpnRestriction,
          SurveillanceError(:final currentData) when currentData != null =>
            currentData.vpnRestriction,
          _ => _cachedVpn,
        };

        if (vpnData == null) {
          return SizedBox(height: 90.h);
        }

        return VpnRestrictionView(vpnData: vpnData);
      },
    );
  }
}

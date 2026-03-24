import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/surveillance/surveillance_bloc.dart';
import '../../bloc/surveillance/surveillance_state.dart';
import '../../widgets/surveillance/vpn_restriction_view.dart';
import '../../../domain/entities/surveillance/surveillance_data.dart';

class SurveillancePage extends StatelessWidget {
  const SurveillancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveillanceBloc, SurveillanceState>(
      builder: (ctx, state) {
        SurveillanceData? currentData;
        if (state is SurveillanceLoaded) {
          currentData = state.data;
        } else if (state is SurveillanceUpdateSuccess) {
          currentData = state.data;
        } else if (state is SurveillanceError) {
          currentData = state.currentData;
        }

        if (state is SurveillanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (currentData == null) {
          return const Center(child: Text('No data available'));
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: VpnRestrictionView(vpnData: currentData.vpnRestriction),
        );
      },
    );
  }
}

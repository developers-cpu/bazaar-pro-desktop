import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_radio_button.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../bloc/surveillance/surveillance_bloc.dart';
import '../../bloc/surveillance/surveillance_event.dart';
import '../../../domain/entities/surveillance/surveillance_vpn.dart';

class VpnRestrictionView extends StatelessWidget {
  final SurveillanceVpn vpnData;
  const VpnRestrictionView({super.key, required this.vpnData});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildRadioGroup(
              context: context,
              title: 'For Master',
              value: vpnData.masterRestriction,
              onChanged: (val) {
                if (val != null) {
                  context.read<SurveillanceBloc>().add(
                    UpdateVpnRestrictionEvent(masterRestriction: val),
                  );
                }
              },
            ),
            SizedBox(width: 50.w),
            _buildRadioGroup(
              context: context,
              title: 'For Client',
              value: vpnData.clientRestriction,
              onChanged: (val) {
                if (val != null) {
                  context.read<SurveillanceBloc>().add(
                    UpdateVpnRestrictionEvent(clientRestriction: val),
                  );
                }
              },
            ),
            const Spacer(),
            CustomActionButton(
              text: 'Update',
              onPressed: () {
                context.read<SurveillanceBloc>().add(
                  SaveSurveillanceDataEvent(),
                );
              },
              width: 100.w,
              height: 35.h,
              borderRadius: 8.r,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioGroup({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            AppRadioButton<bool>(
              value: true,
              groupValue: value,
              label: 'Yes',
              onChanged: onChanged,
            ),
            SizedBox(width: 16.w),
            AppRadioButton<bool>(
              value: false,
              groupValue: value,
              label: 'No',
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}

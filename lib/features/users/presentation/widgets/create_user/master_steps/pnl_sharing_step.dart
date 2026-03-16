import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';
class PnlSharingStep extends StatefulWidget {
  const PnlSharingStep({super.key});
  @override
  State<PnlSharingStep> createState() => _PnlSharingStepState();
}
class _PnlSharingStepState extends State<PnlSharingStep> {
  late TextEditingController _plSharingController;
  late TextEditingController _brokerageSharingController;
  @override
  void initState() {
    super.initState();
    final state = context.read<UserFormBloc>().state;
    _plSharingController = TextEditingController(text: state.plSharing);
    _brokerageSharingController = TextEditingController(
      text: state.brokerageSharing,
    );
  }
  @override
  void dispose() {
    _plSharingController.dispose();
    _brokerageSharingController.dispose();
    super.dispose();
  }
  void _updateField(String field, String value) {
    context.read<UserFormBloc>().add(
      UpdateFormFieldEvent(fieldName: field, value: value),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(
                  controller: _plSharingController,
                  hintText: 'P/L Sharing (%)',
                  height: 35.h,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _updateField('plSharing', v),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Our:60 | Downline: 20 |Upline: 20',
                  style: GoogleFonts.openSans(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(
                  controller: _brokerageSharingController,
                  hintText: 'Brokerage Sharing (%)',
                  height: 35.h,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _updateField('brokerageSharing', v),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Our:60 | Downline: 20 |Upline: 20',
                  style: GoogleFonts.openSans(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

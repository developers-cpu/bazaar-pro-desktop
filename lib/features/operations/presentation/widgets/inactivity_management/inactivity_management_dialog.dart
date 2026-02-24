import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/custom_action_button.dart';

class InactivityManagementDialog extends StatefulWidget {
  const InactivityManagementDialog({super.key});
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (context) => const InactivityManagementDialog(),
    );
  }

  @override
  State<InactivityManagementDialog> createState() =>
      _InactivityManagementDialogState();
}

class _InactivityManagementDialogState
    extends State<InactivityManagementDialog> {
  final TextEditingController _daysCtrl = TextEditingController();
  @override
  void dispose() {
    _daysCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Inactivity Management',
      width: 440.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(15.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please specify the number of days of inactivity after which a user will be marked as inactive.',
            textAlign: TextAlign.start,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'कृपया उन दिनों की संख्या दर्ज करें, जिनके बाद उपयोगकर्ता को निष्क्रिय माना जाएगा',
            textAlign: TextAlign.start,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 15.h),
          CustomInputField(
            controller: _daysCtrl,
            hintText: 'Enter Number of Days',
            width: double.infinity,
            height: 32.h,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20.h),
          Center(
            child: CustomActionButton(
              text: 'Set',
              onPressed: () {
                Navigator.pop(context);
              },
              width: 140.w,
              height: 35.h,
              borderRadius: 6.r,
            ),
          ),
        ],
      ),
    );
  }
}

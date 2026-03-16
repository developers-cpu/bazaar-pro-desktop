import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/custom_action_button.dart';

class InactivityManagementDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Inactivity Management',
      width: 440.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(15.w),
      contentBuilder: (context, onClose) =>
          _InactivityManagementContent(onClose: onClose),
    );
  }
}

class _InactivityManagementContent extends StatefulWidget {
  final VoidCallback onClose;
  const _InactivityManagementContent({Key? key, required this.onClose})
    : super(key: key);
  @override
  State<_InactivityManagementContent> createState() =>
      _InactivityManagementContentState();
}

class _InactivityManagementContentState
    extends State<_InactivityManagementContent> {
  final TextEditingController _daysCtrl = TextEditingController();
  @override
  void dispose() {
    _daysCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            onPressed: widget.onClose,
            width: 140.w,
            height: 35.h,
            borderRadius: 6.r,
          ),
        ),
      ],
    );
  }
}

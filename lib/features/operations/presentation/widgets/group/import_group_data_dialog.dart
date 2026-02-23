import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';

class ImportGroupDataDialog extends StatelessWidget {
  const ImportGroupDataDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Import Group Data',
      width: 500.w,
      showButtons: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInstructions(),
          SizedBox(height: 15.h),
          _buildImportSection(),
          SizedBox(height: 20.h),
          _buildUpdateButton(context),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please make sure required fields given below before creating group - कृपया समूह बनाने से पहले नीचे दिए गए आवश्यक फ़ील्ड सुनिश्चित करें',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 10.h),
        _buildInstructionItem('1. MCX, CE/PE: Lot Max, BreakUp Lot'),
        _buildInstructionItem(
          '2. NSE, GIFT, OTHERS, CDS, COMEX, USSTOCK, CRYPTO, FOREX: Quantity Max, Breakup Quantity',
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildImportSection() {
    return Row(
      children: [
        Expanded(
          child: CustomInputField(
            hintText: 'Browse File',
            width: double.infinity,
            height: 36.h,
          ),
        ),
        SizedBox(width: 12.w),
        CustomActionButton(
          text: 'Import',
          onPressed: () {},
          width: 100.w,
          height: 36.h,
          borderRadius: 8.r,
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Center(
      child: CustomActionButton(
        text: 'Update',
        onPressed: () {
          Navigator.pop(context);
        },
        width: 100.w,
        height: 36.h,
        borderRadius: 8.r,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
class ExchangeSettingsToolbar extends StatelessWidget {
  final int activeTab;
  final int recordCount;
  final TextEditingController searchCtrl;
  const ExchangeSettingsToolbar({
    super.key,
    required this.activeTab,
    required this.recordCount,
    required this.searchCtrl,
  });
  @override
  Widget build(BuildContext context) {
    if (activeTab == 7) {
      return Align(
        alignment: Alignment.centerRight,
        child: Text(
          'RECORD : $recordCount',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      );
    }
    return Column(
      children: [
        Row(
          children: [
            CustomInputField(
              hintText: 'Search',
              controller: searchCtrl,
              prefixSvgPath: AppImages.searchIcon,
              width: 200.w,
              height: 35.h,
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: 5.h),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'RECORD : $recordCount',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}

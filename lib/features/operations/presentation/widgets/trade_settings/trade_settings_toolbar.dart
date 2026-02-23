import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
class TradeSettingsToolbar extends StatelessWidget {
  final int activeTab;
  final int recordCount;
  final TextEditingController searchCtrl;
  const TradeSettingsToolbar({
    super.key,
    required this.activeTab,
    required this.recordCount,
    required this.searchCtrl,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomInputField(
          hintText: 'Search',
          controller: searchCtrl,
          prefixSvgPath: AppImages.searchIcon,
          width: 250.w,
          height: 35.h,
        ),
        const Spacer(),
        Text(
          'RECORD : $recordCount',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
}

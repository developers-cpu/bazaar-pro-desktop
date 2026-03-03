import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';

class SettlementFilterBar extends StatelessWidget {
  final String selectedDateRange;
  final ValueChanged<String?> onDateRangeChanged;
  final VoidCallback onReset;
  final VoidCallback onView;
  const SettlementFilterBar({
    super.key,
    required this.selectedDateRange,
    required this.onDateRangeChanged,
    required this.onReset,
    required this.onView,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          AppDropdown(
            width: 200.w,
            height: 35.h,
            hintText: 'This Week',
            value: selectedDateRange,
            items: const ['This Week', 'Previous Week', 'Custom Period'],
            onChanged: (value) {
              onDateRangeChanged(value);
            },
          ),
          const Spacer(),
          SizedBox(
            height: 35.h,
            width: 100.w,
            child: OutlinedButton(
              onPressed: onReset,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Reset',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            height: 35.h,
            width: 100.w,
            child: ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F4A66),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'View',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class DateRangePickerButton extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const DateRangePickerButton({
    super.key,
    required this.selectedDateRange,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 160.w,
        height: height ?? 35.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.primaryBlue, width: 2.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDateRange != null
                    ? '${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}'
                    : 'Select Date Range',
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.calendar_today,
              size: 16.sp,
              color: AppColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}

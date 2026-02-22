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
          border: Border.all(color: AppColors.primaryBlue, width: 1.0),
          borderRadius: BorderRadius.circular(8.r),
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
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: 0.15,
                  color: selectedDateRange != null
                      ? AppColors.textColor(context)
                      : AppColors.primaryBlue,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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

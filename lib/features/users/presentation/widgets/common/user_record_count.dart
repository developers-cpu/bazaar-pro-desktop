import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class UserRecordCount extends StatelessWidget {
  final int count;
  final String label;
  final bool compact;
  const UserRecordCount({
    super.key,
    required this.count,
    this.label = 'RECORD',
    this.compact = false,
  });
  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Text(
        '$label : $count',
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        alignment: Alignment.centerRight,
        child: Text(
          '$label : $count',
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      );
    }
  }
}

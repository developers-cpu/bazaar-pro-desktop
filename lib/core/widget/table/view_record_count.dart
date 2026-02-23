import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class ViewRecordCount extends StatelessWidget {
  final int count;
  final String label;
  const ViewRecordCount({Key? key, required this.count, this.label = 'RECORD'})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        child: Text(
          '$label : $count',
          style: GoogleFonts.openSans(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

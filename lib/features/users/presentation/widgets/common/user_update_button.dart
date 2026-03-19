import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UserUpdateButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const UserUpdateButton({
    super.key,
    required this.onPressed,
    this.label = 'Update',
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1F4A66),
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        minimumSize: Size(120.w, 35.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
      child: Text(
        label,
        style: GoogleFonts.openSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
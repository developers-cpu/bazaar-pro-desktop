import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';

class UserPlaceholderTab extends StatelessWidget {
  final String title;
  const UserPlaceholderTab({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 48.sp, color: AppColors.greyBorder),
          SizedBox(height: 16.h),
          Text(
            '$title Tab Under Construction',
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

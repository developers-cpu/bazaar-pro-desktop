import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



/// View and Reset Buttons Widget
class ViewResetButtons extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onReset;
  final bool isLoading;
  final String viewText;
  final String resetText;

  const ViewResetButtons({
    Key? key,
    this.onView,
    this.onReset,
    this.isLoading = false,
    this.viewText = 'View',
    this.resetText = 'Reset',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Reset Button
        _buildResetButton(),
        SizedBox(width: 12.w),
        // View Button
        _buildViewButton(),
      ],
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: 120.w,
      height: 40.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onReset,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          backgroundColor: AppColors.white,
        ),
        child: Text(
          resetText,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildViewButton() {
    return SizedBox(
      width: 120.w,
      height: 40.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onView,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: AppColors.white,
          ),
        )
            : Text(
          viewText,
          style: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

/// Record Count Widget
/// Shows the total record count
class RecordCountWidget extends StatelessWidget {
  final int count;
  final String label;

  const RecordCountWidget({
    Key? key,
    required this.count,
    this.label = 'RECORD',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label : $count',
      style: GoogleFonts.openSans(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
      ),
    );
  }
}
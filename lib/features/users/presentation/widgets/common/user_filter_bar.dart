import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Filter bar widget for Users section pages
class UserFilterBar extends StatelessWidget {
  final List<UserFilterDropdown> filters;
  final Widget? trailing;
  final int recordCount;
  final VoidCallback? onReset;
  final VoidCallback? onView;
  final bool isLoading;

  const UserFilterBar({
    super.key,
    required this.filters,
    this.trailing,
    this.recordCount = 0,
    this.onReset,
    this.onView,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Filter dropdowns using AppDropdown
          ...filters.map(
            (filter) => Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: AppDropdown(
                type: AppDropdownType.simple,
                hintText: filter.hint,
                value: filter.value,
                items: filter.items,
                onChanged: filter.onChanged,
                width: 150.w,
              ),
            ),
          ),
          const Spacer(),
          // Record count
          Text(
            'RECORD : $recordCount',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(width: 16.w),
          // Reset Button
          _buildActionButton(
            label: 'Reset',
            onPressed: isLoading ? null : onReset,
            isPrimary: false,
          ),
          SizedBox(width: 8.w),
          // View Button
          _buildActionButton(
            label: 'View',
            onPressed: isLoading ? null : onView,
            isPrimary: true,
          ),
          if (trailing != null) ...[SizedBox(width: 16.w), trailing!],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback? onPressed,
    required bool isPrimary,
  }) {
    return SizedBox(
      height: 36.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primaryBlue : AppColors.white,
          foregroundColor: isPrimary ? AppColors.white : AppColors.primaryBlue,
          elevation: 0,
          side: isPrimary ? null : BorderSide(color: AppColors.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
        ),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Filter dropdown configuration
class UserFilterDropdown {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const UserFilterDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });
}

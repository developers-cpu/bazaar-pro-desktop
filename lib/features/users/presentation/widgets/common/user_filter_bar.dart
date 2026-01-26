import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:bazarpro/features/users/presentation/widgets/common/user_record_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/user_filter_dropdown.dart';

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
          ...filters.map(
                (filter) => Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: AppDropdown(
                type: AppDropdownType.simple,
                hintText: filter.hint,
                value: filter!.value,
                items: filter.items,
                onChanged: filter.onChanged,
                width: 150.w,
                height: 40.h,
              ),
            ),
          ),

          const Spacer(),
          UserRecordCount(
            count: recordCount,
            compact: true,
          ),

          SizedBox(width: 16.w),
          _buildActionButton(
            label: 'Reset',
            onPressed: isLoading ? null : onReset,
            isPrimary: false,
          ),
          SizedBox(width: 8.w),

          _buildActionButton(
            label: 'View',
            onPressed: isLoading ? null : onView,
            isPrimary: true,
          ),

          if (trailing != null) ...[
            SizedBox(width: 16.w),
            trailing!,
          ],
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
          side: isPrimary
              ? null
              : BorderSide(color: AppColors.borderColor, width: 1),
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


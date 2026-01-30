import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../users/domain/entities/user.dart';

class UserSharingDetailsTab extends StatelessWidget {
  final User user;

  const UserSharingDetailsTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildSharingCard(context, 'PL Sharing', [
              {'Person': 'Person', 'Share': 'Share'}, 
              {'Person': 'Admin', 'Share': '5000%'},
              {'Person': 'Master ( RAJ701 )', 'Share': '5000%'},
              {'Person': 'Client ( marko )', 'Share': '000%'},
            ]),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildSharingCard(context, 'Brokerage Sharing', [
              {'Person': 'Person', 'Share': 'Share'}, 
              {'Person': 'Admin', 'Share': '5000%'},
              {'Person': 'Master ( RAJ701 )', 'Share': '5000%'},
              {'Person': 'Client ( marko )', 'Share': '000%'},
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSharingCard(
    BuildContext context,
    String title,
    List<Map<String, String>> data,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryBlue),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          Divider(color: AppColors.primaryBlue, height: 1),
          ...data.map((item) {
            final isHeader = item['Person'] == 'Person';
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['Person']!,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                      color: isHeader
                          ? AppColors.primaryBlue
                          : AppColors.textColor(context),
                    ),
                  ),
                  Text(
                    item['Share']!,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                      color: isHeader
                          ? AppColors.primaryBlue
                          : AppColors.textColor(context),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

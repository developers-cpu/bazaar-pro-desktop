import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widget/common_dilog_box.dart';
class AboutDialogBox extends StatelessWidget {
  const AboutDialogBox({Key? key}) : super(key: key);
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'About',
      content: const AboutDialogBox(),
      showButtons: false,
      width: 600.w,
      height: 350.h,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Operating System',
              style: GoogleFonts.openSans(
                fontSize: 22.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0C2436),  
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(4.w),
              child: Image.asset(
                AppImages.appLogo,
                height: 40.h,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 40);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoCard(
              iconWidget: Icon(
                Icons.computer_outlined,
                color: const Color(0xFFEAA92A),
                size: 30.sp,
              ),
              title: 'Component',
              value: 'BAZAAR PRO',
            ),
            _buildInfoCard(
              iconWidget: Stack(
                children: [
                  Icon(
                    Icons.chat_bubble,
                    color: const Color(0xFF4FA4F4),
                    size: 28.sp,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAA92A),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: 'Version Number',
              value: '1.40',
            ),
            _buildInfoCard(
              iconWidget: Icon(
                Icons.gavel_outlined,
                color: const Color(0xFFEAA92A),
                size: 30.sp,
              ),
              title: 'Copyrights',
              value: 'Copyrights @ 25',
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildInfoCard({
    required Widget iconWidget,
    required String title,
    required String value,
    bool isLast = false,
  }) {
    return SizedBox(
      width: 170.w,
      height: 110.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 15.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFDDEBF3),  
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: 0, left: 16.w, child: iconWidget),
        ],
      ),
    );
  }
}

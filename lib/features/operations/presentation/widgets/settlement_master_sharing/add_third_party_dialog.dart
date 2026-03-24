import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';

class AddThirdPartyDialog {
  static void show({
    required BuildContext context,
    required void Function(String name) onAdd,
  }) {
    final controller = TextEditingController();

    CommonDialog.show(
      context: context,
      title: 'Add Third Party',
      width: 360.w,
      showButtons: false,
      autoPop: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Third Party Name',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 38.h,
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter third party name',
                hintStyle: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 1.5,
                  ),
                ),
              ),
              style: GoogleFonts.openSans(fontSize: 13.sp),
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: SizedBox(
              height: 35.h,
              width: 120.w,
              child: ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    onAdd(name);
                  }
                  CommonDialog.closeRecent();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F4A66),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Add',
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

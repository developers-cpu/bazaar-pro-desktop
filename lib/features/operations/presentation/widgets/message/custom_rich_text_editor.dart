import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';

class CustomRichTextEditor extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final double? height;
  const CustomRichTextEditor({
    super.key,
    this.controller,
    this.hintText = 'Type here',
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.primaryBlue, width: 1),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 8.w,
                  top: 8.h,
                  right: 8.w,
                  bottom: 4.h,
                ),
                child: Row(
                  children: [
                    _buildIcon(Icons.format_align_left),
                    _buildIcon(Icons.format_italic),
                    _buildIcon(Icons.text_fields),
                    _buildIcon(Icons.format_bold),
                    _buildIcon(Icons.zoom_out_map),
                    _buildIcon(Icons.link),
                    _buildIcon(Icons.undo),
                    _buildIcon(Icons.redo),
                    _buildIcon(Icons.menu),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 13.sp,
                        color: AppColors.primaryBlue,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: GoogleFonts.openSans(
                      fontSize: 13.sp,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 2.h,
            right: 2.w,
            child: Icon(
              Icons.signal_cellular_4_bar,
              size: 14.sp,
              color: AppColors.primaryBlue.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Icon(icon, size: 18.sp, color: AppColors.primaryBlue),
    );
  }
}

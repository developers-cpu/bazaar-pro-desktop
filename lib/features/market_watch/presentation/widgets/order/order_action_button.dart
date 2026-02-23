import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
class OrderActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final bool isLoading;
  final bool hasTopMargin;
  final bool isDarkMode;
  const OrderActionButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.borderColor,
    this.isLoading = false,
    this.hasTopMargin = true,
    this.isDarkMode = false,
  }) : super(key: key);
  Color get _borderColor => borderColor ?? LightThemeColors.primaryColor;
  Color get _textColor => LightThemeColors.textColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTopMargin) SizedBox(height: 19.h),
        SizedBox(
          height: 45.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: _textColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(color: _borderColor, width: 2),
              ),
              disabledBackgroundColor: AppColors.white.withOpacity(0.7),
            ),
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                    ),
                  )
                : Text(
                    label,
                    style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

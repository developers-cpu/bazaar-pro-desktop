import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/svg_icon.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final String? svgIconPath;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final double? height;

  const CustomInputField({
    Key? key,
    required this.hintText,
    this.svgIconPath,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45.h,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: enabled,
        readOnly: readOnly,
        style: GoogleFonts.openSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.15,
          color: AppColors.primaryBlue,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0.15,
            color: AppColors.primaryBlue,
          ),
          isDense: true,

          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: height != null ? height! / 3 : 14.h,
          ),

          errorStyle: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 1.0,
            color: AppColors.errorColor,
          ),
          border: _buildBorder(),
          enabledBorder: _buildBorder(),
          focusedBorder: _buildBorder(),
          errorBorder: _buildBorder(isError: true),
          focusedErrorBorder: _buildBorder(isError: true),
          disabledBorder: _buildBorder(isDisabled: true),
          suffixIcon: _buildSuffixIcon(),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (suffixIcon != null) {
      return IconButton(
        icon: Icon(suffixIcon, size: 24.sp, color: AppColors.primaryBlue),
        onPressed: onSuffixIconPressed,
      );
    }

    if (svgIconPath != null) {
      return Padding(
        padding: EdgeInsets.all(10.w),
        child: SvgIcon(assetPath: svgIconPath!, isActive: true, size: 24.sp),
      );
    }

    return null;
  }

  OutlineInputBorder _buildBorder({
    bool isError = false,
    bool isDisabled = false,
  }) {
    Color borderColor;
    if (isError) {
      borderColor = AppColors.errorColor;
    } else if (isDisabled) {
      borderColor = AppColors.greyBorder;
    } else {
      borderColor = AppColors.primaryBlue;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: borderColor, width: 2.w),
    );
  }
}

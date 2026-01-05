import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widget/svg_icon.dart';

/// Custom Input Field Widget
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 48,
        maxWidth: 500,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: enabled,
        style: GoogleFonts.openSans(
          fontSize: AppDimensions.fontSizeL,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.15,
          color: AppColors.primaryBlue,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            fontSize: AppDimensions.fontSizeL,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0.15,
            color: AppColors.primaryBlue,
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingM,
          ),
          errorStyle: GoogleFonts.openSans(
            fontSize: AppDimensions.fontSizeS,
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
      ),
    );
  }

  /// Build suffix icon widget
  Widget? _buildSuffixIcon() {
    if (suffixIcon != null) {
      return IconButton(
        icon: Icon(
          suffixIcon,
          size: AppDimensions.iconSizeL,
          color: AppColors.primaryBlue,
        ),
        onPressed: onSuffixIconPressed,
      );
    }

    if (svgIconPath != null) {
      return Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: SvgIcon(
          assetPath: svgIconPath!,
          isActive: true,
          size: AppDimensions.iconSizeL,
          activeColor: AppColors.primaryBlue,
          inactiveColor: AppColors.greyBorder,
        ),
      );
    }

    return null;
  }


  /// Build input border
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
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
      borderSide: BorderSide(
        color: borderColor,
        width: AppDimensions.borderWidthMedium,
      ),
    );
  }
}
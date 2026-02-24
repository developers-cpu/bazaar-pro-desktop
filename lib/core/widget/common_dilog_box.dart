import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bazarpro/core/widget/custom_action_button.dart';
import 'package:bazarpro/core/widget/custom_outlined_button.dart';
import '../../../../core/constants/app_colors.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? headerColor;
  final bool showButtons;
  final bool isDarkMode;
  final String cancelText;
  final String saveText;
  final EdgeInsets? contentPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final bool scrollable;
  final bool autoPop;
  const CommonDialog({
    Key? key,
    required this.title,
    required this.content,
    this.onCancel,
    this.onSave,
    this.width,
    this.height,
    this.backgroundColor,
    this.headerColor,
    this.showButtons = true,
    this.isDarkMode = false,
    this.cancelText = 'Cancel',
    this.saveText = 'Save',
    this.contentPadding,
    this.buttonWidth,
    this.buttonHeight,
    this.scrollable = true,
    this.autoPop = true,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required String title,
    required Widget content,
    VoidCallback? onCancel,
    VoidCallback? onSave,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? headerColor,
    bool showButtons = true,
    bool isDarkMode = false,
    String cancelText = 'Cancel',
    String saveText = 'Save',
    EdgeInsets? contentPadding,
    double? buttonWidth,
    double? buttonHeight,
    bool scrollable = true,
    bool autoPop = true,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => CommonDialog(
        title: title,
        content: content,
        onCancel: onCancel,
        onSave: onSave,
        width: width,
        height: height,
        backgroundColor: backgroundColor,
        headerColor: headerColor,
        showButtons: showButtons,
        isDarkMode: isDarkMode,
        cancelText: cancelText,
        saveText: saveText,
        contentPadding: contentPadding,
        buttonWidth: buttonWidth,
        buttonHeight: buttonHeight,
        scrollable: scrollable,
        autoPop: autoPop,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ??
        (isDarkMode
            ? DarkThemeColors.cardBackground
            : LightThemeColors.cardBackground);
    final headerBgColor =
        headerColor ??
        (isDarkMode ? LightThemeColors.primaryColor : AppColors.primaryBlue);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.transparent,
      child: Container(
        width: width ?? 400.w,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: height != null ? MainAxisSize.max : MainAxisSize.min,
          children: [
            _buildHeader(context, headerBgColor),
            Flexible(
              child: scrollable
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: contentPadding ?? EdgeInsets.all(20.w),
                        child: content,
                      ),
                    )
                  : Padding(
                      padding: contentPadding ?? EdgeInsets.all(20.w),
                      child: content,
                    ),
            ),
            if (showButtons) ...[
              _buildButtons(context),
              SizedBox(height: 20.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color headerBgColor) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 40.h,
        color: headerBgColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (onCancel != null) {
                  onCancel!();
                }
                Navigator.pop(context);
              },
              child: Icon(Icons.close, size: 18.sp, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final primaryColor = isDarkMode
        ? const Color(0xFF1F4A66)
        : (headerColor ?? AppColors.primaryBlue);
    final btnHeight = buttonHeight ?? 45.h;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomOutlinedActionButton(
              text: cancelText,
              onPressed: () {
                if (onCancel != null) {
                  onCancel!();
                }
                if (autoPop) {
                  Navigator.pop(context);
                }
              },
              height: btnHeight,
              borderColor: primaryColor,
              textColor: primaryColor,
              borderRadius: 10.r,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomActionButton(
              text: saveText,
              onPressed: () {
                if (onSave != null) {
                  onSave!();
                }
                if (autoPop) {
                  Navigator.pop(context);
                }
              },
              height: btnHeight,
              backgroundColor: primaryColor,
              borderRadius: 10.r,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

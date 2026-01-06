import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widget/svg_icon.dart';


class ContextMenuWidget extends StatelessWidget {
  final Offset position;
  final VoidCallback onViewChart;
  final VoidCallback onArrangeSymbol;
  final VoidCallback onSetSymbolFont;
  final VoidCallback onFitToSize;
  final VoidCallback onSymbolInfo;
  final VoidCallback onGrid;
  final VoidCallback onCut;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onDelete;
  final bool canPaste;
  final bool canUndo;
  final bool canRedo;

  const ContextMenuWidget({
    Key? key,
    required this.position,
    required this.onViewChart,
    required this.onArrangeSymbol,
    required this.onSetSymbolFont,
    required this.onFitToSize,
    required this.onSymbolInfo,
    required this.onGrid,
    required this.onCut,
    required this.onCopy,
    required this.onPaste,
    required this.onUndo,
    required this.onRedo,
    required this.onDelete,
    this.canPaste = true,
    this.canUndo = true,
    this.canRedo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 200.w,
        constraints: BoxConstraints(
          maxHeight: 450.h,
        ),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              icon: AppImages.menu1Icon,
              text: AppStrings.viewChart,
              onTap: onViewChart,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu2con,
              text: AppStrings.arrangeSymbol,
              onTap: onArrangeSymbol,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu3Icon,
              text: AppStrings.setSymbolFont,
              onTap: onSetSymbolFont,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu10Icon,
              text: AppStrings.fitToSize,
              onTap: onFitToSize,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu4Icon,
              text: AppStrings.symbolInfo,
              onTap: onSymbolInfo,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu5Icon,
              text: AppStrings.grid,
              onTap: onGrid,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu6Icon,
              text: AppStrings.cut,
              onTap: onCut,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu6Icon,
              text: AppStrings.copy,
              onTap: onCopy,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu7Icon,
              text: AppStrings.paste,
              onTap: onPaste,
              enabled: canPaste,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu8Icon,
              text: AppStrings.undo,
              onTap: onUndo,
              enabled: canUndo,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu8Icon,
              text: AppStrings.redo,
              onTap: onRedo,
              enabled: canRedo,
            ),
            SizedBox(height: 5.h),
            _buildMenuItem(
              icon: AppImages.menu9Icon,
              text: AppStrings.delete,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual menu item with icon and text
  Widget _buildMenuItem({
    required String icon,
    required String text,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        height: 29.h,
        padding: EdgeInsets.only(
          top: 5.h,
          right: 10.w,
          bottom: 5.h,
          left: 10.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          children: [
            SvgIcon(
              assetPath: icon,
              isActive: enabled,
              size: 18.w,
            ),

            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: enabled
                      ? AppColors.primaryBlue
                      : AppColors.primaryBlue.withOpacity(0.4),
                  letterSpacing: 0.25,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
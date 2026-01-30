import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widget/svg_icon.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart';

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
  final VoidCallback onBuyOrder;
  final VoidCallback onSellOrder;
  final VoidCallback onMarketDepth;
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
    required this.onBuyOrder,
    required this.onSellOrder,
    required this.onMarketDepth,
    this.canPaste = true,
    this.canUndo = true,
    this.canRedo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.isDarkMode;

        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10.r),
          color: isDark
              ? DarkThemeColors.contextMenuBackground
              : LightThemeColors.contextMenuBackground,
          child: Container(
            width: 220.w,
            constraints: BoxConstraints(maxHeight: 550.h),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isDark
                  ? DarkThemeColors.contextMenuBackground
                  : LightThemeColors.contextMenuBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark
                    ? DarkThemeColors.cardBorderColor
                    : LightThemeColors.cardBorderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(isDark ? 0.3 : 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  _buildMenuItem(
                    icon: Icons.shopping_cart,
                    text: 'Buy Order',
                    shortcut: 'F1',
                    onTap: onBuyOrder,
                    isDark: isDark,
                    iconColor: const Color(0xFF0066FF),
                  ),
                  SizedBox(height: 5.h),
                  
                  _buildMenuItem(
                    icon: Icons.sell,
                    text: 'Sell Order',
                    shortcut: 'F2',
                    onTap: onSellOrder,
                    isDark: isDark,
                    iconColor: const Color(0xFFFF0000),
                  ),
                  SizedBox(height: 5.h),
                  
                  _buildMenuItem(
                    icon: Icons.analytics,
                    text: 'Market Depth',
                    shortcut: 'F5',
                    onTap: onMarketDepth,
                    isDark: isDark,
                    iconColor: const Color(0xFF2C5766),
                  ),
                  _buildDivider(isDark),
                  _buildMenuItemSvg(
                    icon: AppImages.menu1Icon,
                    text: AppStrings.viewChart,
                    onTap: onViewChart,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu2con,
                    text: AppStrings.arrangeSymbol,
                    onTap: onArrangeSymbol,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu3Icon,
                    text: AppStrings.setSymbolFont,
                    onTap: onSetSymbolFont,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu10Icon,
                    text: AppStrings.fitToSize,
                    onTap: onFitToSize,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu4Icon,
                    text: AppStrings.symbolInfo,
                    onTap: onSymbolInfo,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu5Icon,
                    text: AppStrings.grid,
                    onTap: onGrid,
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMenuItemSvg(
                    icon: AppImages.menu6Icon,
                    text: AppStrings.cut,
                    onTap: onCut,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu6Icon,
                    text: AppStrings.copy,
                    onTap: onCopy,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu7Icon,
                    text: AppStrings.paste,
                    onTap: onPaste,
                    enabled: canPaste,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu8Icon,
                    text: AppStrings.undo,
                    onTap: onUndo,
                    enabled: canUndo,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu8Icon,
                    text: AppStrings.redo,
                    onTap: onRedo,
                    enabled: canRedo,
                    isDark: isDark,
                  ),
                  SizedBox(height: 5.h),
                  _buildMenuItemSvg(
                    icon: AppImages.menu9Icon,
                    text: AppStrings.delete,
                    onTap: onDelete,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(
        height: 1,
        color: isDark
            ? DarkThemeColors.dividerColor
            : LightThemeColors.dividerColor,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool isDark,
    String? shortcut,
    Color? iconColor,
    bool enabled = true,
  }) {
    final textColor = isDark
        ? DarkThemeColors.textColor
        : LightThemeColors.textColor;
    final hoverColor = isDark
        ? DarkThemeColors.contextMenuHover
        : LightThemeColors.contextMenuHover;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(5.r),
      hoverColor: hoverColor,
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.w,
              color: enabled
                  ? (iconColor ?? textColor)
                  : textColor.withOpacity(0.4),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: enabled ? textColor : textColor.withOpacity(0.4),
                  letterSpacing: 0.25,
                  height: 1.0,
                ),
              ),
            ),
            if (shortcut != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  shortcut,
                  style: GoogleFonts.openSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemSvg({
    required String icon,
    required String text,
    required VoidCallback onTap,
    required bool isDark,
    bool enabled = true,
  }) {
    final textColor = isDark
        ? DarkThemeColors.textColor
        : LightThemeColors.textColor;
    final hoverColor = isDark
        ? DarkThemeColors.contextMenuHover
        : LightThemeColors.contextMenuHover;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(5.r),
      hoverColor: hoverColor,
      child: Container(
        height: 29.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          children: [
            SvgIcon(
              assetPath: icon,
              isActive: enabled && isDark,
              size: 18.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: enabled ? textColor : textColor.withOpacity(0.4),
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
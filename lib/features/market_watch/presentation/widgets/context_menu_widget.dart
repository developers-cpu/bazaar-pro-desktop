import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(8.r),
      color: AppColors.white,
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.greyBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              icon: Icons.shopping_cart,
              text: 'Buy Order',
              shortcut: 'F1',
              onTap: onBuyOrder,
              iconColor: const Color(0xFF0066FF),
            ),
            _buildMenuItem(
              icon: Icons.sell,
              text: 'Sell Order',
              shortcut: 'F2',
              onTap: onSellOrder,
              iconColor: const Color(0xFFFF0000),
            ),
            _buildMenuItem(
              icon: Icons.analytics,
              text: 'Market Depth',
              shortcut: 'F5',
              onTap: onMarketDepth,
              iconColor: const Color(0xFF2C5766),
            ),
            _buildDivider(),
            _buildMenuItemSvg(
              icon: AppImages.menu1Icon,
              text: AppStrings.viewChart,
              onTap: onViewChart,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu2con,
              text: AppStrings.arrangeSymbol,
              onTap: onArrangeSymbol,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu3Icon,
              text: AppStrings.setSymbolFont,
              onTap: onSetSymbolFont,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu10Icon,
              text: AppStrings.fitToSize,
              onTap: onFitToSize,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu4Icon,
              text: AppStrings.symbolInfo,
              onTap: onSymbolInfo,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu5Icon,
              text: AppStrings.grid,
              onTap: onGrid,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu6Icon,
              text: AppStrings.cut,
              onTap: onCut,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu7Icon,
              text: AppStrings.paste,
              onTap: onPaste,
              enabled: canPaste,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu8Icon,
              text: AppStrings.undo,
              onTap: onUndo,
              enabled: canUndo,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu8Icon,
              text: AppStrings.redo,
              onTap: onRedo,
              enabled: canRedo,
            ),
            _buildMenuItemSvg(
              icon: AppImages.menu9Icon,
              text: AppStrings.delete,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Divider(height: 1, color: AppColors.greyBorder),
    );
  }
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    String? shortcut,
    Color? iconColor,
    bool enabled = true,
  }) {
    final textColor = AppColors.primaryBlue;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4.r),
      hoverColor: AppColors.primaryBlue.withOpacity(0.06),
      child: Container(
        height: 24.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14.w,
              color: enabled
                  ? (iconColor ?? textColor)
                  : textColor.withOpacity(0.4),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                  color: enabled ? textColor : textColor.withOpacity(0.4),
                  height: 1.0,
                ),
              ),
            ),
            if (shortcut != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Text(
                  shortcut,
                  style: GoogleFonts.openSans(
                    fontSize: 9.sp,
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
    bool enabled = true,
  }) {
    final textColor = AppColors.primaryBlue;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4.r),
      hoverColor: AppColors.primaryBlue.withOpacity(0.06),
      child: Container(
        height: 24.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
        child: Row(
          children: [
            SvgIcon(assetPath: icon, isActive: false, size: 14.w),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                  color: enabled ? textColor : textColor.withOpacity(0.4),
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

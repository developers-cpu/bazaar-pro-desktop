import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widget/svg_icon.dart';
import 'table_text_style_helper.dart';

/// Widget for building table header cell - centered
class TableHeaderCell extends StatelessWidget {
  final String title;
  final bool isDark;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showSortIcon;

  const TableHeaderCell({
    Key? key,
    required this.title,
    required this.isDark,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    this.showSortIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TableTextStyleHelper.getTextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w600,
              color: LightThemeColors.textColor,
            ),
          ),
          if (showSortIcon && title.isNotEmpty) ...[
            SizedBox(width: 4.w),
            SvgIcon(
              assetPath: AppImages.sortIcon,
              isActive: isDark,
              size: (fontSize * 1.1).sp,
            ),
          ],
        ],
      ),
    );
  }
}
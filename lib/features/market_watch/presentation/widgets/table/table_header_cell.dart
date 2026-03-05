import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/svg_icon.dart';
import 'table_text_style_helper.dart';

class TableHeaderCell extends StatelessWidget {
  final String title;
  final bool isDark;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showSortIcon;
  final bool isLast;
  const TableHeaderCell({
    Key? key,
    required this.title,
    required this.isDark,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    this.showSortIcon = true,
    this.isLast = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return const SizedBox.shrink();
    }
    final iconSize = (fontSize * 1.0).sp;
    final headerTitle = title.toUpperCase();
    final textStyle = TableTextStyleHelper.getTextStyle(
      fontFamily: fontFamily,
      fontSize: (fontSize - 1).sp,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryTextColor,
    );
    Widget content;
    if (!showSortIcon) {
      content = Center(
        child: Text(
          headerTitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      );
    } else {
      content = Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                headerTitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
            SvgIcon(
              assetPath: AppImages.sortIcon,
              isActive: isDark,
              size: iconSize,
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(left: 0.w),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.8),
                  width: 1,
                ),
              ),
            ),
      child: content,
    );
  }
}

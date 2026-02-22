import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'view_data_table.dart';
import 'view_table_cell_styles.dart';

class ViewDataTableFooter extends StatelessWidget {
  final List<ViewTableColumn> columns;
  final Map<String, String> values;
  final bool isDarkMode;
  final bool showDividers;
  final Color? textColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextAlign? textAlign;

  const ViewDataTableFooter({
    Key? key,
    required this.columns,
    required this.values,
    this.isDarkMode = false,
    this.showDividers = true,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dividerColor = isDarkMode
        ? DarkThemeColors.dividerColor.withOpacity(0.5)
        : AppColors.dividerColor(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: columns.asMap().entries.map((entry) {
          final index = entry.key;
          final column = entry.value;
          final value = values[column.id] ?? '';
          final isLast = index == columns.length - 1;
          return Container(
            width: column.width,
            alignment: textAlign == null
                ? (column.isNumeric
                      ? Alignment.centerRight
                      : Alignment.centerLeft)
                : Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: (isLast || !showDividers)
                  ? null
                  : Border(right: BorderSide(color: dividerColor, width: 0.5)),
            ),
            child: Text(
              value,
              style: ViewTableCellStyles.getTextStyle(
                isDark: isDarkMode,
                fontWeight: FontWeight.bold,
                color: textColor ?? AppColors.primaryBlue,
              ),
              textAlign:
                  textAlign ??
                  (column.isNumeric ? TextAlign.right : TextAlign.left),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }
}

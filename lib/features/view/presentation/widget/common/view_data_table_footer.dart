import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'view_data_table.dart';
import 'view_table_cell_styles.dart';
class ViewDataTableFooter extends StatelessWidget {
  final List<ViewTableColumn> columns;
  final Map<String, String> values;
  final bool isDarkMode;
  const ViewDataTableFooter({
    Key? key,
    required this.columns,
    required this.values,
    this.isDarkMode = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dividerColor = isDarkMode
        ? DarkThemeColors.dividerColor.withOpacity(0.5)
        : AppColors.white.withOpacity(0.8);
    return Row(
      children: columns.asMap().entries.map((entry) {
        final index = entry.key;
        final column = entry.value;
        final value = values[column.id] ?? '';
        final isLast = index == columns.length - 1;
        return Container(
          width: column.width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(right: BorderSide(color: dividerColor, width: 1)),
          ),
          child: Text(
            value,
            style: ViewTableCellStyles.getTextStyle(
              isDark: isDarkMode,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}

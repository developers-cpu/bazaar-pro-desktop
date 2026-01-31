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
    return Row(
      children: columns.map((column) {
        final value = values[column.id] ?? '';

        return Container(
          width: column.width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
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

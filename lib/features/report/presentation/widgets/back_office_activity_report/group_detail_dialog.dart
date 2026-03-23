import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/back_office_activity_report.dart';

class GroupDetailDialog extends StatefulWidget {
  final BackOfficeActivityReport activity;

  const GroupDetailDialog({super.key, required this.activity});

  static void show(BuildContext context, BackOfficeActivityReport activity) {
    CommonDialog.show(
      context: context,
      title: 'Group',
      width: 1000.w,
      height: 600.h,
      scrollable: false,
      content: GroupDetailDialog(activity: activity),
      showButtons: false,
    );
  }

  @override
  State<GroupDetailDialog> createState() => _GroupDetailDialogState();
}

class _GroupDetailDialogState extends State<GroupDetailDialog> {
  DateTimeRange? _selectedDateRange;

  List<Map<String, dynamic>> _getMockData() {
    final updatedByList = [
      'Admin',
      'Super Admin',
      'Master',
      'Admin',
      'Admin',
      'Super Admin',
      'Super Admin',
      'Admin',
      'Super Admin',
      'Admin',
    ];
    final groupValues = [
      'Yes',
      'No',
      'Yes',
      'No',
      'Yes',
      'No',
      'No',
      'No',
      'Yes',
      'Yes',
    ];
    return List.generate(
      10,
      (i) => {
        'groupUpdated': groupValues[i],
        'updatedOn': DateTime(2026, 2, 12, 12, 30, 52),
        'updatedBy': updatedByList[i],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _getMockData();
    final columns = const [
      ViewTableColumn(id: 'groupUpdated', label: 'GROUP UPDATED', width: 250),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 200),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterBar(context),
        SizedBox(height: 4.h),
        ViewRecordCount(count: data.length),
        SizedBox(height: 4.h),
        Expanded(
          child: ViewDataTable<Map<String, dynamic>>(
            columns: columns,
            data: data,
            idExtractor: (item) => data.indexOf(item).toString(),
            isDarkMode: false,
            autoFit: true,
            comparatorBuilder: (item, columnId) {
              final val = item[columnId];
              if (val is num) return val;
              if (val is DateTime) return val;
              return val?.toString() ?? '';
            },
            cellBuilder: (item, column) {
              switch (column.id) {
                case 'updatedOn':
                  return ViewDateTimeCell(
                    dateTime: item['updatedOn'],
                    isDark: false,
                  );
                default:
                  return ViewTextCell(
                    text: item[column.id]?.toString() ?? '-',
                    isDark: false,
                  );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Row(
      children: [
        DateRangePickerButton(
          width: 200.w,
          height: 35.h,
          selectedDateRange: _selectedDateRange,
          onTap: () {},
          onDateRangeSelected: (range) {
            setState(() => _selectedDateRange = range);
          },
        ),
        const Spacer(),
        ViewResetButtons(
          onReset: () {
            setState(() => _selectedDateRange = null);
          },
          onView: () {},
        ),
      ],
    );
  }
}

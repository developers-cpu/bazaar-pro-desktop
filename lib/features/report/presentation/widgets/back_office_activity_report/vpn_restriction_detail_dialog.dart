import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/back_office_activity_report.dart';

class VpnRestrictionDetailDialog extends StatefulWidget {
  final BackOfficeActivityReport activity;

  const VpnRestrictionDetailDialog({super.key, required this.activity});

  static void show(BuildContext context, BackOfficeActivityReport activity) {
    CommonDialog.show(
      context: context,
      title: 'VPN Restrictions',
      width: 1050.w,
      height: 650.h,
      scrollable: false,
      content: VpnRestrictionDetailDialog(activity: activity),
      showButtons: false,
    );
  }

  @override
  State<VpnRestrictionDetailDialog> createState() =>
      _VpnRestrictionDetailDialogState();
}

class _VpnRestrictionDetailDialogState
    extends State<VpnRestrictionDetailDialog> {
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
    return List.generate(
      updatedByList.length,
      (i) => {
        'oldMaster': i.isEven ? 'Not Allowed' : 'Allowed',
        'newMaster': i.isEven ? 'Allowed' : 'Not Allowed',
        'oldClient': i.isEven ? 'Allowed' : 'Not Allowed',
        'newClient': i.isEven ? 'Not Allowed' : 'Allowed',
        'updatedOn': DateTime(2026, 12, 2, 12, 30, 52),
        'updatedBy': updatedByList[i],
      },
    );
  }

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'oldMaster', label: 'OLD MASTER', width: 130),
      ViewTableColumn(id: 'newMaster', label: 'NEW MASTER', width: 130),
      ViewTableColumn(id: 'oldClient', label: 'OLD CLIENT', width: 130),
      ViewTableColumn(id: 'newClient', label: 'NEW CLIENT', width: 130),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 180),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 130),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = _getMockData();
    final columns = _getColumns();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterBar(context),
        SizedBox(height: 8.h),
        ViewRecordCount(count: data.length),
        SizedBox(height: 4.h),
        Expanded(
          child: ViewDataTable<Map<String, dynamic>>(
            columns: columns,
            data: data,
            idExtractor: (item) =>
                item['updatedBy'].toString() +
                item['oldMaster'].toString() +
                data.indexOf(item).toString(),
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
            setState(() {
              _selectedDateRange = null;
            });
          },
          onView: () {},
        ),
      ],
    );
  }
}
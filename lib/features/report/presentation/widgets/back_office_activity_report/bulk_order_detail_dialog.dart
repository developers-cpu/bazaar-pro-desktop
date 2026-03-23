import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/app_tab_bar.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/back_office_activity_report.dart';

class BulkOrderDetailDialog extends StatefulWidget {
  final BackOfficeActivityReport activity;

  const BulkOrderDetailDialog({super.key, required this.activity});

  static void show(BuildContext context, BackOfficeActivityReport activity) {
    CommonDialog.show(
      context: context,
      title: 'Bulk Order',
      width: 1050.w,
      height: 650.h,
      scrollable: false,
      content: BulkOrderDetailDialog(activity: activity),
      showButtons: false,
    );
  }

  @override
  State<BulkOrderDetailDialog> createState() => _BulkOrderDetailDialogState();
}

class _BulkOrderDetailDialogState extends State<BulkOrderDetailDialog> {
  int _activeTab = 0;
  DateTimeRange? _selectedDateRange;
  String? _selectedExchange;

  static const _tabs = ['Interval Time', 'Total Quantity', 'Trade SL/Limit%'];

  static const _exchanges = [
    'NSE',
    'MCX',
    'OTHER',
    'CE/PE',
    'GIFT',
    'COMEX FUTURE',
    'COMEX SPOT',
    'USSTOCK',
    'CRYPTO',
    'FOREX',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, dynamic>> _getMockData(int tabIndex) {
    final symbols = [
      'ABB25DECFUT',
      'ABB25DECFUT',
      'ABB25DECFUT',
      'ABB25DECFUT',
      'ABB25DECFUT',
    ];

    switch (tabIndex) {
      case 0:
        return List.generate(
          symbols.length,
          (i) => {
            'symbol': symbols[i],
            'oldValue': i.isEven ? '30' : '10',
            'newValue': i.isEven ? '10' : '30',
            'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
            'updatedBy': 'DEMO4',
          },
        );
      case 1:
        return List.generate(
          symbols.length,
          (i) => {
            'symbol': symbols[i],
            'oldValue': i.isEven ? '200' : '100',
            'newValue': i.isEven ? '100' : '200',
            'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
            'updatedBy': 'DEMO4',
          },
        );
      case 2:
        return List.generate(
          symbols.length,
          (i) => {
            'symbol': symbols[i],
            'oldValue': i.isEven ? '05' : '100',
            'newValue': i.isEven ? '100' : '05',
            'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
            'updatedBy': 'DEMO4',
          },
        );
      default:
        return [];
    }
  }

  List<ViewTableColumn> _getColumnsForTab(int tabIndex) {
    final labels = ['INTERVAL TIME', 'TOTAL QUANTITY', 'TRADE SL/LIMIT %'];
    final label = labels[tabIndex];
    return [
      const ViewTableColumn(
        id: 'symbol',
        label: 'SYMBOL',
        width: 200,
        alignment: Alignment.centerLeft,
      ),
      ViewTableColumn(
        id: 'oldValue',
        label: 'OLD $label',
        width: 180,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'newValue',
        label: 'NEW $label',
        width: 180,
        headerLines: 2,
      ),
      const ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 160),
      const ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _activeTab;
    final data = _getMockData(currentTab);
    final columns = _getColumnsForTab(currentTab);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterBar(context),
        SizedBox(height: 8.h),
        _buildTabBar(),
        SizedBox(height: 8.h),
        SizedBox(
          width: 200.w,
          child: AppDropdown(
            type: AppDropdownType.simple,
            hintText: 'Exchange',
            value: _selectedExchange,
            items: _exchanges,
            onChanged: (v) {
              setState(() => _selectedExchange = v);
            },
          ),
        ),
        SizedBox(height: 4.h),
        ViewRecordCount(count: data.length),
        SizedBox(height: 4.h),
        Expanded(
          child: ViewDataTable<Map<String, dynamic>>(
            columns: columns,
            data: data,
            idExtractor: (item) =>
                item['symbol'].toString() + currentTab.toString(),
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
              _selectedExchange = null;
            });
          },
          onView: () {},
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return AppTabBar(
      tabs: _tabs.toList(),
      activeTab: _activeTab,
      onTabChanged: (i) => setState(() => _activeTab = i),
    );
  }
}

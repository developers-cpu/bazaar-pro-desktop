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

class ScriptSettingDetailDialog extends StatefulWidget {
  final BackOfficeActivityReport activity;

  const ScriptSettingDetailDialog({super.key, required this.activity});

  static void show(BuildContext context, BackOfficeActivityReport activity) {
    CommonDialog.show(
      context: context,
      title: 'Script Setting',
      width: 1050.w,
      height: 650.h,
      scrollable: false,
      content: ScriptSettingDetailDialog(activity: activity),
      showButtons: false,
    );
  }

  @override
  State<ScriptSettingDetailDialog> createState() =>
      _ScriptSettingDetailDialogState();
}

class _ScriptSettingDetailDialogState extends State<ScriptSettingDetailDialog> {
  int _activeTab = 0;
  DateTimeRange? _selectedDateRange;
  String? _selectedExchange;

  static const _tabs = ['Ban Script', 'Split Script', 'Bonus', 'Dividend'];

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

  static const _symbols5 = [
    'ABB25DECFUT',
    'AXISBANK25DECFUT',
    'ADANIENT25DECFUT',
    'ADANIGREEN25DECFUT',
    'AUROPHARMA25DECFUT',
  ];

  static const _symbolsBonus = [
    'ABB25DECFUT',
    'ABCAPITAL25DECFUT',
    'ADANIENSOL25DECFUT',
    '360ONE25DECFUT',
    'BAJAJ-AUTO25DECFUT',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, dynamic>> _getBanScriptData() {
    final statuses = [
      ['Allowed', 'Not Allowed'],
      ['Not Allowed', 'Allowed'],
      ['Allowed', 'Not Allowed'],
      ['Not Allowed', 'Allowed'],
      ['Allowed', 'Not Allowed'],
    ];
    return List.generate(
      _symbols5.length,
      (i) => {
        'symbol': _symbols5[i],
        'oldValue': statuses[i][0],
        'newValue': statuses[i][1],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getSplitScriptData() {
    final oldDates = [
      '04/01/26',
      '02/01/26',
      '30/12/25',
      '28/12/25',
      '26/12/25',
    ];
    final newDates = [
      '08/01/26',
      '04/01/26',
      '02/01/26',
      '30/12/25',
      '28/12/25',
    ];
    return List.generate(
      _symbols5.length,
      (i) => {
        'symbol': _symbols5[i],
        'oldValue': oldDates[i],
        'newValue': newDates[i],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getBonusData() {
    final oldBonus = ['1:1', '1:2', '1:1', '1:2', '1:1'];
    final newBonus = ['1:2', '1:1', '1:2', '1:1', '1:2'];
    final oldPrice = ['400', '450', '400', '450', '400'];
    final newPrice = ['450', '400', '450', '400', '450'];
    return List.generate(
      _symbolsBonus.length,
      (i) => {
        'symbol': _symbolsBonus[i],
        'oldBonus': oldBonus[i],
        'newBonus': newBonus[i],
        'oldClosePrice': oldPrice[i],
        'newClosePrice': newPrice[i],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getDividendData() {
    final oldDiv = ['5', '10', '5', '10', '5'];
    final newDiv = ['10', '5', '10', '5', '10'];
    final oldPrice = ['400', '450', '400', '450', '400'];
    final newPrice = ['450', '400', '450', '400', '450'];
    return List.generate(
      _symbolsBonus.length,
      (i) => {
        'symbol': _symbolsBonus[i],
        'oldDividend': oldDiv[i],
        'newDividend': newDiv[i],
        'oldClosePrice': oldPrice[i],
        'newClosePrice': newPrice[i],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<ViewTableColumn> _getColumnsForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 180,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(id: 'oldValue', label: 'OLD STATUS', width: 150),
          ViewTableColumn(id: 'newValue', label: 'NEW STATUS', width: 150),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 160),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 1:
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 200,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(id: 'oldValue', label: 'OLD CUT DATE', width: 150),
          ViewTableColumn(id: 'newValue', label: 'NEW CUT DATE', width: 150),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 160),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 2:
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 160,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(
            id: 'oldBonus',
            label: 'OLD\nBONAS',
            width: 100,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'newBonus',
            label: 'NEW\nBONAS',
            width: 100,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'oldClosePrice',
            label: 'OLD CLOSE\nPRICE',
            width: 110,
            headerLines: 2,
            isNumeric: true,
          ),
          ViewTableColumn(
            id: 'newClosePrice',
            label: 'NEW CLOSE\nPRICE',
            width: 110,
            headerLines: 2,
            isNumeric: true,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 110),
        ];
      case 3:
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 160,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(
            id: 'oldDividend',
            label: 'OLD\nDIVIDEND',
            width: 100,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'newDividend',
            label: 'NEW\nDIVIDEND',
            width: 100,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'oldClosePrice',
            label: 'OLD CLOSE\nPRICE',
            width: 110,
            headerLines: 2,
            isNumeric: true,
          ),
          ViewTableColumn(
            id: 'newClosePrice',
            label: 'NEW CLOSE\nPRICE',
            width: 110,
            headerLines: 2,
            isNumeric: true,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 110),
        ];
      default:
        return const [];
    }
  }

  List<Map<String, dynamic>> _getDataForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _getBanScriptData();
      case 1:
        return _getSplitScriptData();
      case 2:
        return _getBonusData();
      case 3:
        return _getDividendData();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _activeTab;
    final data = _getDataForTab(currentTab);
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
                (item['symbol'] ?? '').toString() + currentTab.toString(),
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

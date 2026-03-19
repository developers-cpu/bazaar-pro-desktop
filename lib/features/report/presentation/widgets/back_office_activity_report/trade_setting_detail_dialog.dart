import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/app_radio_button.dart';
import '../../../../../core/widget/app_tab_bar.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/back_office_activity_report.dart';

class TradeSettingDetailDialog extends StatefulWidget {
  final BackOfficeActivityReport activity;

  const TradeSettingDetailDialog({super.key, required this.activity});

  static void show(BuildContext context, BackOfficeActivityReport activity) {
    CommonDialog.show(
      context: context,
      title: 'Trade Setting',
      width: 1050.w,
      height: 650.h,
      scrollable: false,
      content: TradeSettingDetailDialog(activity: activity),
      showButtons: false,
    );
  }

  @override
  State<TradeSettingDetailDialog> createState() =>
      _TradeSettingDetailDialogState();
}

class _TradeSettingDetailDialogState extends State<TradeSettingDetailDialog> {
  int _activeTab = 0;
  DateTimeRange? _selectedDateRange;
  String? _selectedExchange;
  String _marginType = 'Percentage Wise';

  static const _tabs = ['Margin', 'Brokerage', 'Leverage', 'Trade Seconds'];

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

  static const _symbols = [
    'ABB25DECFUT',
    'ABCAPITAL25DECFUT',
    'ADANIENSOL25DECFUT',
    '360ONE25DECFUT',
    'BAJAJ-AUTO25DECFUT',
    'AXISBANK25DECFUT',
    'ADANIENT25DECFUT',
    'ADANIGREEN25DECFUT',
    'AUROPHARMA25DECFUT',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, dynamic>> _getMarginData() {
    return List.generate(
      9,
      (i) => {
        'symbol': 'ABB25DECFUT',
        'oldInt': '100',
        'newInt': '100',
        'oldCf': '100',
        'newCf': '100',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getBrokerageData() {
    return [
      {
        'symbol': 'ABB25DECFUT',
        'oldTurnover': '2500',
        'newTurnover': '2500',
        'oldLotWise': '2500',
        'newLotWise': '2500',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
      {
        'symbol': 'AXISBANK25DECFUT',
        'oldTurnover': '2500',
        'newTurnover': '2500',
        'oldLotWise': '2500',
        'newLotWise': '2500',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
      {
        'symbol': 'ADANIENT25DECFUT',
        'oldTurnover': '2500',
        'newTurnover': '2500',
        'oldLotWise': '2500',
        'newLotWise': '2500',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
      {
        'symbol': 'ADANIGREEN25DECFUT',
        'oldTurnover': '2500',
        'newTurnover': '2500',
        'oldLotWise': '2500',
        'newLotWise': '2500',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
      {
        'symbol': 'AUROPHARMA25DECFUT',
        'oldTurnover': '2500',
        'newTurnover': '2500',
        'oldLotWise': '-',
        'newLotWise': '-',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    ];
  }

  List<Map<String, dynamic>> _getLeverageData() {
    final leverages = [
      ['1:1', '1:2'],
      ['1:2', '1:1'],
      ['1:1', '1:2'],
      ['1:2', '1:1'],
      ['1:1', '1:2'],
      ['1:2', '1:1'],
      ['1:1', '1:2'],
      ['1:2', '1:1'],
      ['1:1', '1:2'],
    ];
    final exchanges = [
      'NSE',
      'MCX',
      'OTHER',
      'CE/PE',
      'GIFT',
      'COMEX FUTURE',
      'USSTOCK',
      'CRYPTO',
      'FOREX',
    ];
    return List.generate(
      exchanges.length,
      (i) => {
        'exch': exchanges[i],
        'oldLeverage': leverages[i][0],
        'newLeverage': leverages[i][1],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getTradeSecondsData() {
    return List.generate(
      5,
      (i) => {
        'symbol': _symbols[i],
        'oldSeconds': '02',
        'newSeconds': '05',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<ViewTableColumn> _getColumnsForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        final suffix = _marginType == 'Percentage Wise' ? '%' : '(A)';
        return [
          const ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 150,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(
            id: 'oldInt',
            label: 'OLD INT\nMARGIN $suffix',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'newInt',
            label: 'NEW INT\nMARGIN $suffix',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'oldCf',
            label: 'OLD CF\nMARGIN $suffix',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'newCf',
            label: 'NEW CF\nMARGIN $suffix',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          const ViewTableColumn(
            id: 'updatedOn',
            label: 'UPDATED ON',
            width: 150,
          ),
          const ViewTableColumn(
            id: 'updatedBy',
            label: 'UPDATED BY',
            width: 100,
          ),
        ];
      case 1:
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 160,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(
            id: 'oldTurnover',
            label: 'OLD\nTURNOVER WISE',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'newTurnover',
            label: 'NEW\nTURNOVER WISE',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'oldLotWise',
            label: 'OLD\nLOT WISE BRK',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          ViewTableColumn(
            id: 'newLotWise',
            label: 'NEW\nLOT WISE BRK',
            width: 120,
            isNumeric: true,
            headerLines: 2,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100),
        ];
      case 2:
        return const [
          ViewTableColumn(
            id: 'exch',
            label: 'EXCH',
            width: 150,
            alignment: Alignment.center,
          ),
          ViewTableColumn(id: 'oldLeverage', label: 'OLD LEVERAGE', width: 180),
          ViewTableColumn(id: 'newLeverage', label: 'NEW LEVERAGE', width: 180),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 3:
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 200,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(
            id: 'oldSeconds',
            label: 'OLD TRADE SECONDS',
            width: 160,
          ),
          ViewTableColumn(
            id: 'newSeconds',
            label: 'NEW TRADE SECONDS',
            width: 160,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      default:
        return const [];
    }
  }

  List<Map<String, dynamic>> _getDataForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _getMarginData();
      case 1:
        return _getBrokerageData();
      case 2:
        return _getLeverageData();
      case 3:
        return _getTradeSecondsData();
      default:
        return [];
    }
  }

  bool _tabHasExchangeFilter(int tabIndex) {
    return tabIndex == 0 || tabIndex == 1 || tabIndex == 3;
  }

  bool _tabHasRadioButtons(int tabIndex) {
    return tabIndex == 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _activeTab;
    final data = _getDataForTab(currentTab);
    final columns = _getColumnsForTab(currentTab);
    final hasExchangeFilter = _tabHasExchangeFilter(currentTab);
    final hasRadio = _tabHasRadioButtons(currentTab);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterBar(context),
        SizedBox(height: 8.h),
        _buildTabBar(),
        if (hasExchangeFilter || hasRadio) ...[
          SizedBox(height: 8.h),
          _buildSubFilterRow(hasExchangeFilter, hasRadio),
        ],
        SizedBox(height: 4.h),
        ViewRecordCount(count: data.length),
        SizedBox(height: 4.h),
        Expanded(
          child: ViewDataTable<Map<String, dynamic>>(
            columns: columns,
            data: data,
            idExtractor: (item) =>
                (item['exch'] ?? item['symbol'] ?? '').toString() +
                currentTab.toString() +
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

  Widget _buildSubFilterRow(bool hasExchangeFilter, bool hasRadio) {
    return Row(
      children: [
        if (hasExchangeFilter)
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
        if (hasRadio) ...[
          SizedBox(width: 16.w),
          AppRadioButton<String>(
            value: 'Percentage Wise',
            groupValue: _marginType,
            label: 'Percentage Wise',
            onChanged: (v) {
              setState(() => _marginType = v!);
            },
          ),
          SizedBox(width: 12.w),
          AppRadioButton<String>(
            value: 'Amount Wise',
            groupValue: _marginType,
            label: 'Amount Wise',
            onChanged: (v) {
              setState(() => _marginType = v!);
            },
          ),
        ],
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
              _marginType = 'Percentage Wise';
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
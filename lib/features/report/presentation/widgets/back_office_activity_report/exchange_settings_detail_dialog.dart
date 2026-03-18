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

class ExchangeSettingsDetailDialog extends StatefulWidget {
  final BackOfficeActivityReport activity;

  const ExchangeSettingsDetailDialog({super.key, required this.activity});

  static void show(BuildContext context, BackOfficeActivityReport activity) {
    CommonDialog.show(
      context: context,
      title: 'Exchange Settings',
      width: 1000.w,
      height: 650.h,
      scrollable: false,
      content: ExchangeSettingsDetailDialog(activity: activity),
      showButtons: false,
    );
  }

  @override
  State<ExchangeSettingsDetailDialog> createState() =>
      _ExchangeSettingsDetailDialogState();
}

class _ExchangeSettingsDetailDialogState
    extends State<ExchangeSettingsDetailDialog> {
  int _activeTab = 0;
  DateTimeRange? _selectedDateRange;
  String? _tradeAttrExchange;
  String? _defaultSymbolExchange;

  static const _tabs = [
    'High Low Between Trade Limit',
    'Order Type',
    'Odd Lot',
    'Trade Attribute',
    'Exchange Sequence',
    'Default Symbol',
  ];

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

  List<Map<String, dynamic>> _getHighLowData() {
    final yesNo = [
      true,
      false,
      true,
      false,
      true,
      false,
      false,
      true,
      false,
      true,
    ];
    return List.generate(
      _exchanges.length,
      (i) => {
        'exch': _exchanges[i],
        'oldValue': yesNo[i] ? 'Yes' : 'No',
        'newValue': yesNo[i] ? 'No' : 'Yes',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getOrderTypeData() {
    final oldValues = [
      'Limit, SL',
      'Market',
      'SL',
      'Market',
      'Market',
      'Market',
      'Market',
      'Market',
      'Market',
      'Market , Limit, SL',
    ];
    final newValues = [
      'Market , Limit, SL',
      'Limit, SL',
      'Market',
      'SL',
      'SL',
      'SL',
      'SL',
      'SL',
      'SL',
      'Market',
    ];
    return List.generate(
      _exchanges.length,
      (i) => {
        'exch': _exchanges[i],
        'oldValue': oldValues[i],
        'newValue': newValues[i],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getOddLotData() {
    final oldYes = [
      true,
      true,
      false,
      false,
      true,
      true,
      true,
      false,
      false,
      true,
    ];
    return List.generate(
      _exchanges.length,
      (i) => {
        'exch': _exchanges[i],
        'oldValue': oldYes[i] ? 'Yes' : 'No',
        'newValue': oldYes[i] ? 'No' : 'Yes',
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getTradeAttributeData() {
    final symbols = [
      'ABB25DECFUT',
      'ABCAPITAL25DECFUT',
      'ADANIENSO L25DECFUT',
      '360ONE25DECFUT',
      'BAJAJ-AUTO25DECFUT',
    ];
    final oldValues = ['Full', 'Block', 'Close', 'Full', 'Block'];
    final newValues = ['Close', 'Full', 'Block', 'Close', 'Full'];
    return List.generate(
      symbols.length,
      (i) => {
        'symbol': symbols[i],
        'oldValue': oldValues[i],
        'newValue': newValues[i],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getExchangeSequenceData() {
    final oldSeq = ['01', '02', '03', '04', '05', '06', '06', '08', '09', '10'];
    final newSeq = ['02', '04', '06', '08', '10', '01', '01', '03', '05', '07'];
    return List.generate(
      _exchanges.length,
      (i) => {
        'exch': _exchanges[i],
        'oldValue': oldSeq[i],
        'newValue': newSeq[i],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<Map<String, dynamic>> _getDefaultSymbolData() {
    final symbols = [
      'ABB25DECFUT',
      'ABCAPITAL25DECFUT',
      'ADANIENSOL25DECFUT',
      '360ONE25DECFUT',
      'BAJAJ-AUTO25DECFUT',
    ];
    final oldValues = [
      'Not Allowed',
      'Allowed',
      'Not Allowed',
      'Allowed',
      'Not Allowed',
    ];
    final newValues = [
      'Allowed',
      'Not Allowed',
      'Allowed',
      'Not Allowed',
      'Allowed',
    ];
    return List.generate(
      symbols.length,
      (i) => {
        'symbol': symbols[i],
        'oldValue': oldValues[i],
        'newValue': newValues[i],
        'updatedOn': DateTime(2025, 12, 26, 12, 0, 0),
        'updatedBy': 'DEMO4',
      },
    );
  }

  List<ViewTableColumn> _getColumnsForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // High Low Between Trade Limit
        return const [
          ViewTableColumn(
            id: 'exch',
            label: 'EXCH',
            width: 130,
            alignment: Alignment.center,
          ),
          ViewTableColumn(
            id: 'oldValue',
            label: 'OLD BWN H.L. LIMIT PLACE',
            width: 200,
          ),
          ViewTableColumn(
            id: 'newValue',
            label: 'NEW BWN H.L. LIMIT PLACE',
            width: 200,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 1: // Order Type
        return const [
          ViewTableColumn(
            id: 'exch',
            label: 'EXCH',
            width: 130,
            alignment: Alignment.center,
          ),
          ViewTableColumn(id: 'oldValue', label: 'OLD TICK SIZE', width: 200),
          ViewTableColumn(id: 'newValue', label: 'NEW TICK SIZE', width: 200),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 2: // Odd Lot
        return const [
          ViewTableColumn(
            id: 'exch',
            label: 'EXCH',
            width: 130,
            alignment: Alignment.center,
          ),
          ViewTableColumn(id: 'oldValue', label: 'OLD ODD LOT', width: 200),
          ViewTableColumn(id: 'newValue', label: 'NEW ODD LOT', width: 200),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 3: // Trade Attribute
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 180,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(
            id: 'oldValue',
            label: 'OLD MARKET PRICE TYPE',
            width: 180,
          ),
          ViewTableColumn(
            id: 'newValue',
            label: 'NEW MARKET PRICE TYPE',
            width: 180,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 4: // Exchange Sequence
        return const [
          ViewTableColumn(
            id: 'exch',
            label: 'EXCH',
            width: 130,
            alignment: Alignment.center,
          ),
          ViewTableColumn(id: 'oldValue', label: 'OLD SEQUENCE', width: 200),
          ViewTableColumn(id: 'newValue', label: 'NEW SEQUENCE', width: 200),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 120),
        ];
      case 5: // Default Symbol
        return const [
          ViewTableColumn(
            id: 'symbol',
            label: 'SYMBOL',
            width: 180,
            alignment: Alignment.centerLeft,
          ),
          ViewTableColumn(id: 'oldValue', label: 'OLD SETTINGS', width: 180),
          ViewTableColumn(id: 'newValue', label: 'NEW SETTINGS', width: 180),
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
        return _getHighLowData();
      case 1:
        return _getOrderTypeData();
      case 2:
        return _getOddLotData();
      case 3:
        return _getTradeAttributeData();
      case 4:
        return _getExchangeSequenceData();
      case 5:
        return _getDefaultSymbolData();
      default:
        return [];
    }
  }

  bool _tabHasExchangeFilter(int tabIndex) {
    return tabIndex == 3 || tabIndex == 5;
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _activeTab;
    final data = _getDataForTab(currentTab);
    final columns = _getColumnsForTab(currentTab);
    final hasExchangeFilter = _tabHasExchangeFilter(currentTab);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterBar(context),
        SizedBox(height: 8.h),
        _buildTabBar(),
        if (hasExchangeFilter) ...[
          SizedBox(height: 8.h),
          _buildExchangeDropdown(currentTab),
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
                currentTab.toString(),
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
              _tradeAttrExchange = null;
              _defaultSymbolExchange = null;
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

  Widget _buildExchangeDropdown(int tabIndex) {
    final value = tabIndex == 3 ? _tradeAttrExchange : _defaultSymbolExchange;
    return SizedBox(
      width: 200.w,
      child: AppDropdown(
        type: AppDropdownType.simple,
        hintText: 'Exchange',
        value: value,
        items: const [
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
        ],
        onChanged: (v) {
          setState(() {
            if (tabIndex == 3) {
              _tradeAttrExchange = v;
            } else {
              _defaultSymbolExchange = v;
            }
          });
        },
      ),
    );
  }
}

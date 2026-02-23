import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../injection_container.dart';
import '../../bloc/trade_settings/trade_settings_bloc.dart';
import '../../bloc/trade_settings/trade_settings_event.dart';
import '../../bloc/trade_settings/trade_settings_state.dart';
import '../operations_page_wrapper.dart';
import '../../widgets/trade_settings/trade_settings_tab_bar.dart';
import '../../widgets/trade_settings/trade_settings_headers.dart';
import '../../widgets/trade_settings/trade_settings_toolbar.dart';
import '../../widgets/trade_settings/trade_settings_data_table.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/trade_settings/trade_setting.dart';

class TradeSettingsPageWithAppBar extends StatelessWidget {
  const TradeSettingsPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TradeSettingsBloc>()..add(LoadTradeSettingsEvent()),
      child: Builder(
        builder: (context) {
          return OperationsPageWrapper(
            pageTitle: 'Trade Setting',
            onExportPdf: () {},
            onExportExcel: () {},
            child: const TradeSettingsPage(),
          );
        },
      ),
    );
  }
}

class TradeSettingsPage extends StatefulWidget {
  const TradeSettingsPage({super.key});

  @override
  State<TradeSettingsPage> createState() => _TradeSettingsPageState();
}

class _TradeSettingsPageState extends State<TradeSettingsPage> {
  int _activeTab = 0;
  final _searchCtrl = TextEditingController();
  Set<String> _selectedIds = {};
  String? _selectedExchange;
  String _marginType = 'Percentage Wise';
  String _brokerageType = 'Turnover Wise';

  final _tabs = const ['Margin', 'Brokerage', 'Leverage', 'Trade Seconds'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TradeSettingsBloc, TradeSettingsState>(
      listener: (ctx, state) {
        if (state is TradeSettingsUpdateSuccess) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is TradeSettingsError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (_, state) {
        final settings = (state is TradeSettingsLoaded) ? state.settings : [];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TradeSettingsTabBar(
                tabs: _tabs,
                activeTab: _activeTab,
                onTabChanged: (i) => setState(() {
                  _activeTab = i;
                  _selectedIds.clear();
                  _selectedExchange = null;
                }),
              ),
              SizedBox(height: 10.h),
              if (_selectedExchange != null) ...[
                _buildDetailHeader(),
                SizedBox(height: 10.h),
              ],
              TradeSettingsHeaders(
                activeTab: _activeTab,
                marginType: _marginType,
                onMarginTypeChanged: (type) =>
                    setState(() => _marginType = type),
                brokerageType: _brokerageType,
                onBrokerageTypeChanged: (type) =>
                    setState(() => _brokerageType = type),
              ),
              SizedBox(height: 10.h),
              TradeSettingsToolbar(
                activeTab: _activeTab,
                recordCount: _selectedExchange != null
                    ? _getDetailData(settings).length
                    : settings.length,
                searchCtrl: _searchCtrl,
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: _selectedExchange != null
                    ? _buildDetailBody(state, settings)
                    : _buildBody(state, settings),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => setState(() {
            _selectedExchange = null;
            _selectedIds.clear();
          }),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 18.sp, color: AppColors.primaryBlue),
              SizedBox(width: 8.w),
              Text(
                'Trade Settings  ($_selectedExchange)',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(TradeSettingsState state, List<dynamic> displayData) {
    if (state is TradeSettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is TradeSettingsError) {
      return Center(child: Text(state.message));
    }

    return TradeSettingsDataTable(
      data: displayData,
      selectedIds: _selectedIds,
      onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
      activeTab: _activeTab,
      onExchangeTap: _activeTab != 2
          ? (exchange) => setState(() {
              _selectedExchange = exchange;
              _selectedIds.clear();
            })
          : null,
    );
  }

  List<dynamic> _getDetailData(List<dynamic> settings) {
    return settings
        .where((s) => s is TradeSetting && s.exchange == _selectedExchange)
        .toList();
  }

  Widget _buildDetailBody(TradeSettingsState state, List<dynamic> settings) {
    if (state is TradeSettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is TradeSettingsError) {
      return Center(child: Text(state.message));
    }

    final detailData = _getDetailData(settings);

    return ViewDataTable(
      data: detailData,
      columns: [
        ViewTableColumn(
          id: 'checkbox',
          label: '',
          width: 50.w,
          sortable: false,
          customHeaderWidget: Checkbox(
            value:
                _selectedIds.length == detailData.length &&
                detailData.isNotEmpty,
            onChanged: (val) {
              if (val == true) {
                setState(() {
                  _selectedIds = detailData
                      .whereType<TradeSetting>()
                      .map((e) => e.id)
                      .toSet();
                });
              } else {
                setState(() => _selectedIds = {});
              }
            },
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        ..._detailColumnsForTab(),
      ],
      cellBuilder: (item, column) {
        if (item is! TradeSetting) return const SizedBox.shrink();

        if (column.id == 'checkbox') {
          return Checkbox(
            value: _selectedIds.contains(item.id),
            onChanged: (_) {
              final newSelection = Set<String>.from(_selectedIds);
              if (newSelection.contains(item.id)) {
                newSelection.remove(item.id);
              } else {
                newSelection.add(item.id);
              }
              setState(() => _selectedIds = newSelection);
            },
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }

        if (column.id == 'symbol') {
          return Text(
            item.exchange,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              color: AppColors.primaryBlue,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        return _buildDetailCell(item, column.id);
      },
      idExtractor: (item) {
        if (item is! TradeSetting) return '';
        return item.id;
      },
      selectedId: _selectedIds.isNotEmpty ? _selectedIds.first : null,
      onRowTap: (item) {
        if (item is TradeSetting) {
          final newSelection = Set<String>.from(_selectedIds);
          if (newSelection.contains(item.id)) {
            newSelection.remove(item.id);
          } else {
            newSelection.add(item.id);
          }
          setState(() => _selectedIds = newSelection);
        }
      },
      autoFit: true,
    );
  }

  List<ViewTableColumn> _detailColumnsForTab() {
    switch (_activeTab) {
      case 0:
        final cols = <ViewTableColumn>[
          ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
          ViewTableColumn(id: 'marginType', label: 'MARGIN TYPE', width: 150.w),
        ];
        if (_marginType == 'Percentage Wise' || _marginType == 'Both') {
          cols.addAll([
            ViewTableColumn(
              id: 'intMarginPercentage',
              label: 'INT MARGIN (%)',
              width: 150.w,
            ),
            ViewTableColumn(
              id: 'cfMarginPercentage',
              label: 'CF MARGIN (%)',
              width: 150.w,
            ),
          ]);
        }
        if (_marginType == 'Amount Wise' || _marginType == 'Both') {
          cols.addAll([
            ViewTableColumn(
              id: 'intMarginAmt',
              label: 'INT MARGIN (Amt.)',
              width: 150.w,
            ),
            ViewTableColumn(
              id: 'cfMarginAmt',
              label: 'CF MARGIN (Amt.)',
              width: 150.w,
            ),
          ]);
        }
        cols.addAll([
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ]);
        return cols;
      case 1:
        final bCols = <ViewTableColumn>[
          ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
          ViewTableColumn(
            id: 'brokerageType',
            label: 'BROKERAGE TYPE',
            width: 150.w,
          ),
        ];
        if (_brokerageType == 'Turnover Wise' || _brokerageType == 'Both') {
          bCols.add(
            ViewTableColumn(
              id: 'turnoverWiseBrokerageRs',
              label: 'TURNOVER WISE BROKERAGE(Rs)',
              width: 220.w,
            ),
          );
        }
        if (_brokerageType == 'Lot Wise' || _brokerageType == 'Both') {
          bCols.add(
            ViewTableColumn(
              id: 'lotWiseBrokerageAmt',
              label: 'LOT WISE BROKERAGE(Amt.)',
              width: 200.w,
            ),
          );
        }
        bCols.addAll([
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ]);
        return bCols;
      case 2:
        return [
          ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
          ViewTableColumn(
            id: 'leverageMultiplier',
            label: 'LEVERAGE',
            width: 200.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
      case 3:
        return [
          ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
          ViewTableColumn(
            id: 'tradeSecondsLimit',
            label: 'TRADE SECONDS',
            width: 200.w,
          ),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
      default:
        return [
          ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 180.w),
          ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200.w),
          ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100.w),
        ];
    }
  }

  Widget _buildDetailCell(TradeSetting item, String colId) {
    String text = '';
    switch (colId) {
      case 'marginType':
        text = item.marginType ?? '-';
        break;
      case 'intMarginPercentage':
        text = item.intMarginPercentage ?? '-';
        break;
      case 'cfMarginPercentage':
        text = item.cfMarginPercentage ?? '-';
        break;
      case 'intMarginAmt':
        text = item.intMarginAmt ?? '-';
        break;
      case 'cfMarginAmt':
        text = item.cfMarginAmt ?? '-';
        break;
      case 'brokerageType':
        text = item.brokerageType ?? '-';
        break;
      case 'turnoverWiseBrokerageRs':
        text = item.turnoverWiseBrokerageRs ?? '-';
        break;
      case 'lotWiseBrokerageAmt':
        text = item.lotWiseBrokerageAmt ?? '-';
        break;
      case 'leverageMultiplier':
        text = item.leverageMultiplier ?? '-';
        break;
      case 'tradeSecondsLimit':
        text = item.tradeSecondsLimit ?? '-';
        break;
      case 'updatedOn':
        text = item.updatedOn;
        break;
      case 'updatedBy':
        text = item.updatedBy;
        break;
    }
    return Text(
      text,
      style: TextStyle(fontSize: 12.sp),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/trades/trade.dart';
import '../../bloc/trade/trades_bloc.dart';
import '../../bloc/trade/trades_event.dart';
import '../../bloc/trade/trades_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class TradesTable extends StatelessWidget {
  final bool showDeviceInfo;
  final bool isDarkMode;
  const TradesTable({
    Key? key,
    this.showDeviceInfo = true,
    this.isDarkMode = false,
  }) : super(key: key);
  List<ViewTableColumn> _getColumns() {
    final columns = <ViewTableColumn>[
      const ViewTableColumn(id: 'userName', label: 'U. NAME', width: 120),
      const ViewTableColumn(id: 'pUser', label: 'P USER', width: 120),
      const ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      const ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
      const ViewTableColumn(
        id: 'orderDateTime',
        label: 'ORDER D/T',
        width: 220,
      ),
      const ViewTableColumn(id: 'buySell', label: 'B/S', width: 280),
      const ViewTableColumn(
        id: 'qty',
        label: 'QTY',
        width: 120,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'lot',
        label: 'LOT',
        width: 100,
        isNumeric: true,
      ),
      const ViewTableColumn(id: 'orderType', label: 'TYPE', width: 100),
      const ViewTableColumn(
        id: 'pl',
        label: 'P/L',
        width: 120,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'triggerPrice',
        label: 'T. PRICE',
        width: 130,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'brokerage',
        label: 'BRK',
        width: 100,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'rPrice',
        label: 'R. PRICE',
        width: 120,
        isNumeric: true,
      ),
    ];
    if (showDeviceInfo) {
      columns.addAll(const [
        ViewTableColumn(
          id: 'executionDateTime',
          label: 'EXECUTION D/T',
          width: 220,
        ),
        ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 400),
        ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 160),
      ]);
    }
    return columns;
  }

  Widget _buildCell(Trade item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'userName':
        return ViewTextCell(text: item.userName, isDark: isDark);
      case 'pUser':
        return ViewTextCell(text: item.pUser, isDark: isDark);
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewLinkCell(text: item.symbol, isDark: isDark);
      case 'orderDateTime':
        return ViewDateTimeCell(dateTime: item.orderDateTime, isDark: isDark);
      case 'buySell':
        return ViewBuySellCell(text: item.buySell, isDark: isDark);
      case 'qty':
        return ViewNumberCell(
          value: item.qty,
          colorByValue: true,
          isDark: isDark,
        );
      case 'lot':
        return ViewTextCell(text: item.lot.toStringAsFixed(2), isDark: isDark);
      case 'orderType':
        return ViewTextCell(text: item.orderType, isDark: isDark);
      case 'pl':
        return ViewNumberCell(
          value: item.pl,
          colorByValue: false,
          isDark: isDark,
        );
      case 'triggerPrice':
        return ViewNumberCell(
          value: item.triggerPrice,
          colorByValue: true,
          isDark: isDark,
        );
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          colorByValue: true,
          isDark: isDark,
        );
      case 'rPrice':
        return ViewNumberCell(
          value: item.rPrice,
          colorByValue: true,
          isDark: isDark,
        );
      case 'executionDateTime':
        return item.executionDateTime != null
            ? ViewDateTimeCell(
                dateTime: item.executionDateTime!,
                isDark: isDark,
              )
            : ViewTextCell(text: '-', isDark: isDark);
      case 'deviceId':
        return ViewTextCell(text: item.deviceId ?? '-', isDark: isDark);
      case 'ipAddress':
        return ViewTextCell(text: item.ipAddress ?? '-', isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradesBloc, TradesState>(
      builder: (context, state) {
        if (state is TradesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TradesError) {
          return _buildErrorState(context, state.message);
        }
        if (state is! TradesLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.totalRecords),
            Expanded(
              child: ViewDataTable<Trade>(
                columns: _getColumns(),
                data: state.filteredTrades,
                idExtractor: (item) => item.id,
                selectedId: state.selectedTradeId,
                sortColumn: state.sortColumn,
                sortAscending: state.sortAscending,
                isDarkMode: isDarkMode,
                emptyMessage: 'No trades found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
                onRowTap: (item) {
                  context.read<TradesBloc>().add(SelectTradeEvent(item.id));
                },
                onSort: (columnId, ascending) {
                  context.read<TradesBloc>().add(
                    SortTradesByColumnEvent(
                      columnId: columnId,
                      ascending: ascending,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: GoogleFonts.openSans(fontSize: 14.sp, color: AppColors.red),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<TradesBloc>().add(const LoadTradesEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

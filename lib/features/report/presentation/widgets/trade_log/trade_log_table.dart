import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../report/domain/entities/trade_log.dart';
import '../../../presentation/bloc/trade_log/trade_log_bloc.dart';
import '../../../presentation/bloc/trade_log/trade_log_event.dart';
import '../../../presentation/bloc/trade_log/trade_log_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class TradeLogTable extends StatelessWidget {
  final bool isDarkMode;
  const TradeLogTable({Key? key, this.isDarkMode = false}) : super(key: key);
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'userName', label: 'U. NAME', width: 120),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
      ViewTableColumn(id: 'orderUpdateType', label: 'O.U. Type', width: 120),
      ViewTableColumn(id: 'userType', label: 'U. Type', width: 120),
      ViewTableColumn(
        id: 'oldQty',
        label: 'OLD QTY',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 100, isNumeric: true),
      ViewTableColumn(
        id: 'oldPrice',
        label: 'OLD PRICE',
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'price', label: 'PRICE', width: 120, isNumeric: true),
      ViewTableColumn(id: 'updateTime', label: 'UPDATE TIME', width: 200),
      ViewTableColumn(id: 'orderDateTime', label: 'Order D/T', width: 200),
      ViewTableColumn(id: 'modifyBy', label: 'MODIFY BY', width: 120),
    ];
  }

  Widget _buildCell(TradeLog item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'userName':
        return ViewTextCell(text: item.userName, isDark: isDark);
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewLinkCell(text: item.symbol, isDark: isDark);
      case 'orderUpdateType':
        return ViewTextCell(text: item.orderUpdateType, isDark: isDark);
      case 'userType':
        return ViewTextCell(text: item.userType, isDark: isDark);
      case 'oldQty':
        return ViewNumberCell(
          value: item.oldQty,
          colorByValue: true,
          isDark: isDark,
        );
      case 'qty':
        return ViewNumberCell(
          value: item.qty,
          colorByValue: true,
          isDark: isDark,
        );
      case 'oldPrice':
        return ViewNumberCell(value: item.oldPrice, isDark: isDark);
      case 'price':
        return ViewNumberCell(value: item.price, isDark: isDark);
      case 'updateTime':
        return ViewDateTimeCell(dateTime: item.updateTime, isDark: isDark);
      case 'orderDateTime':
        return ViewDateTimeCell(dateTime: item.orderDateTime, isDark: isDark);
      case 'modifyBy':
        return ViewTextCell(text: item.modifyBy, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeLogBloc, TradeLogState>(
      builder: (context, state) {
        if (state is TradeLogLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TradeLogError) {
          return _buildErrorState(context, state.message);
        }
        if (state is! TradeLogLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.filteredTradeLogs.length),
            Expanded(
              child: ViewDataTable<TradeLog>(
                columns: _getColumns(),
                data: state.filteredTradeLogs,
                idExtractor: (item) => item.id,
                sortColumn: state.sortColumn,
                sortAscending: state.sortAscending,
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No trade logs found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
                onSort: (columnId, ascending) {
                  context.read<TradeLogBloc>().add(
                    SortTradeLogsEvent(
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
              context.read<TradeLogBloc>().add(const LoadTradeLogsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

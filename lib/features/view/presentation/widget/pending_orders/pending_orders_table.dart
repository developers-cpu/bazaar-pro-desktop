import 'package:bazarpro/features/view/presentation/widget/common/view_data_table.dart';
import 'package:bazarpro/features/view/presentation/widget/common/view_record_count.dart';
import 'package:bazarpro/features/view/presentation/widget/common/view_table_cell_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../bloc/pending_orders/pending_orders_bloc.dart';
import '../../bloc/pending_orders/pending_orders_event.dart';
import '../../bloc/pending_orders/pending_orders_state.dart';

class PendingOrdersTable extends StatelessWidget {
  final bool showDeviceInfo;
  final bool isDarkMode;

  const PendingOrdersTable({
    Key? key,
    this.showDeviceInfo = false,
    this.isDarkMode = false,
  }) : super(key: key);

  List<ViewTableColumn> _getColumns() {
    final columns = <ViewTableColumn>[
      const ViewTableColumn(id: 'userId', label: 'USER ID', width: 120),
      const ViewTableColumn(id: 'upline', label: 'UPLINE', width: 120),
      const ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      const ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
      const ViewTableColumn(id: 'buySell', label: 'B/S', width: 280),
      const ViewTableColumn(id: 'qty', label: 'QTY', width: 120, isNumeric: true),
      const ViewTableColumn(id: 'lot', label: 'LOT', width: 100, isNumeric: true),
      const ViewTableColumn(id: 'triggerPrice', label: 'T. PRICE', width: 130, isNumeric: true),
      const ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 220),
      const ViewTableColumn(id: 'modifyOrderDateTime', label: 'MODIFY ORDER D/T', width: 240),
      const ViewTableColumn(id: 'orderType', label: 'TYPE', width: 100),
      const ViewTableColumn(id: 'cmp', label: 'CMP', width: 120, isNumeric: true),
      const ViewTableColumn(id: 'rPrice', label: 'R.PRICE', width: 120, isNumeric: true),
      const ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 1200),
      const ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 160),
    ];

    return columns;
  }

  Widget _buildCell(PendingOrder item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'userId':
        return ViewTextCell(text: item.userId, isDark: isDark);
      case 'upline':
        return ViewTextCell(text: item.upline, isDark: isDark);
      case 'exchange':
        return ViewTextCell(text: item.exchange, isDark: isDark);
      case 'symbol':
        return ViewLinkCell(text: item.symbol, isDark: isDark);
      case 'buySell':
        return ViewBuySellCell(text: item.buySell, isDark: isDark);
      case 'qty':
        return ViewNumberCell(
          value: item.qty,
          colorByValue: true,
          isDark: isDark,
        );
      case 'lot':
        return ViewTextCell(
          text: item.lot.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'triggerPrice':
        return ViewNumberCell(
          value: item.triggerPrice,
          colorByValue: true,
          isDark: isDark,
        );
      case 'orderDateTime':
        return ViewDateTimeCell(dateTime: item.orderDateTime, isDark: isDark);
      case 'modifyOrderDateTime':
        return ViewDateTimeCell(dateTime: item.modifyOrderDateTime, isDark: isDark);
      case 'orderType':
        return ViewTextCell(text: item.orderType, isDark: isDark);
      case 'cmp':
        return ViewNumberCell(
          value: item.cmp,
          fixedColor: AppColors.primaryBlue,
          isDark: isDark,
        );
      case 'rPrice':
        return ViewNumberCell(
          value: item.rPrice,
          fixedColor: AppColors.primaryBlue,
          isDark: isDark,
        );
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
    return BlocBuilder<PendingOrdersBloc, PendingOrdersState>(
      builder: (context, state) {
        if (state is PendingOrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PendingOrdersError) {
          return _buildErrorState(context, state.message);
        }

        if (state is! PendingOrdersLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [

            ViewRecordCount(count: state.totalRecords),

            Expanded(
              child: ViewDataTable<PendingOrder>(
                columns: _getColumns(),
                data: state.filteredOrders,
                idExtractor: (item) => item.id,
                selectedId: state.selectedOrderId,
                sortColumn: state.sortColumn,
                sortAscending: state.sortAscending,
                isDarkMode: isDarkMode,
                emptyMessage: 'No pending orders found',
                cellBuilder: (item, column) => _buildCell(item, column, isDarkMode),
                onRowTap: (item) {
                  context.read<PendingOrdersBloc>().add(SelectOrderEvent(item.id));
                },
                onSort: (columnId, ascending) {
                  context.read<PendingOrdersBloc>().add(
                    SortByColumnEvent(columnId: columnId, ascending: ascending),
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
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              color: AppColors.red,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<PendingOrdersBloc>().add(const LoadPendingOrdersEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
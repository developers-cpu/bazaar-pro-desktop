import 'package:bazarpro/core/widget/table/view_data_table.dart';
import 'package:bazarpro/core/widget/table/view_record_count.dart';
import 'package:bazarpro/core/widget/table/view_table_cell_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../bloc/pending_orders/pending_orders_bloc.dart';
import '../../bloc/pending_orders/pending_orders_event.dart';
import '../../bloc/pending_orders/pending_orders_state.dart';
import 'trade_details_dialog.dart';
import 'delete_order_dialog.dart';

class PendingOrdersTable extends StatelessWidget {
  final bool showDeviceInfo;
  final bool isDarkMode;
  const PendingOrdersTable({
    Key? key,
    this.showDeviceInfo = false,
    this.isDarkMode = false,
  }) : super(key: key);
  List<ViewTableColumn> _getColumns(bool isClient, {bool isAdmin = false}) {
    if (isClient) {
      return const [
        ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
        ViewTableColumn(id: 'buySell', label: 'B/S', width: 150),
        ViewTableColumn(id: 'qty', label: 'QTY', width: 90, isNumeric: true),
        ViewTableColumn(id: 'lot', label: 'LOT', width: 90, isNumeric: true),
        ViewTableColumn(
          id: 'triggerPrice',
          label: 'PRICE',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'orderDateTime',
          label: 'ORDER D/T',
          width: 170,
          alignment: Alignment.centerRight,
        ),
        ViewTableColumn(
          id: 'modifyOrderDateTime',
          label: 'MODIFY ORDER',
          width: 170,
          alignment: Alignment.centerRight,
        ),
        ViewTableColumn(id: 'cmp', label: 'CMP', width: 90, isNumeric: true),
      ];
    }
    final columns = <ViewTableColumn>[
      const ViewTableColumn(id: 'userId', label: 'USER ID', width: 100),
      const ViewTableColumn(id: 'upline', label: 'UPLINE', width: 100),
      const ViewTableColumn(id: 'exchange', label: 'EXCH', width: 90),
      const ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 130),
      const ViewTableColumn(id: 'buySell', label: 'B/S', width: 170),
      const ViewTableColumn(
        id: 'qty',
        label: 'QTY',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'lot',
        label: 'LOT',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'triggerPrice',
        label: 'T. PRICE',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'orderDateTime',
        label: 'ORDER D/T',
        width: 170,
        alignment: Alignment.centerRight,
      ),
      const ViewTableColumn(
        id: 'modifyOrderDateTime',
        label: 'MODIFY ORDER D/T',
        width: 170,
        alignment: Alignment.centerRight,
      ),
      const ViewTableColumn(id: 'orderType', label: 'TYPE', width: 90),
      const ViewTableColumn(
        id: 'cmp',
        label: 'CMP',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'rPrice',
        label: 'R.PRICE',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 280),
      const ViewTableColumn(id: 'device', label: 'DEVICE', width: 100),
      if (isAdmin) const ViewTableColumn(id: 'city', label: 'CITY', width: 150),
      const ViewTableColumn(
        id: 'ipAddress',
        label: 'IP ADDRESS',
        width: 130,
        isNumeric: true,
      ),
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
        final symbolColor = ViewTableCellStyles.getValueColor(
          item.qty,
          isDark: isDark,
        );
        return ViewTextCell(
          text: item.symbol,
          color: symbolColor,
          isDark: isDark,
          isStart: true,
        );
      case 'buySell':
        return ViewBuySellCell(
          text: item.buySell,
          isDark: isDark,
          isStart: true,
        );
      case 'qty':
        return ViewNumberCell(
          value: item.qty,
          colorByValue: true,
          isDark: isDark,
        );
      case 'lot':
        return ViewNumberCell(
          value: item.lot,
          displayText: item.lot.toStringAsFixed(2),
          colorByValue: false,
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
        return ViewDateTimeCell(
          dateTime: item.modifyOrderDateTime,
          isDark: isDark,
        );
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
      case 'device':
        return ViewTextCell(text: item.device ?? '-', isDark: isDark);
      case 'city':
        return ViewTextCell(text: item.city ?? '-', isDark: isDark);
      case 'ipAddress':
        return ViewTextCell(
          text: item.ipAddress ?? '-',
          isDark: isDark,
          isNumeric: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    final role = authState is AuthAuthenticated
        ? authState.user.role.toLowerCase()
        : '';
    final isAdmin = role == 'admin' || role == 'superadmin';
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
                autoFit: true,
                columns: _getColumns(isClient, isAdmin: isAdmin),
                data: state.filteredOrders,
                idExtractor: (item) => item.id,
                selectedId: state.selectedOrderId,
                sortColumn: state.sortColumn,
                sortAscending: state.sortAscending,
                isDarkMode: isDarkMode,
                emptyMessage: 'No pending orders found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
                onRowTap: (item) {
                  context.read<PendingOrdersBloc>().add(
                    SelectOrderEvent(item.id),
                  );
                },
                onRowSecondaryTap: (item) {
                  context.read<PendingOrdersBloc>().add(
                    SelectOrderEvent(item.id),
                  );
                  if (isClient) {
                    TradeDetailsDialog.show(
                      context: context,
                      order: item,
                      isDarkMode: isDarkMode,
                    );
                  } else {
                    DeleteOrderDialog.show(
                      context: context,
                      order: item,
                      isDarkMode: isDarkMode,
                      onCancel: () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (context.mounted) {
                            TradeDetailsDialog.show(
                              context: context,
                              order: item,
                              isDarkMode: isDarkMode,
                            );
                          }
                        });
                      },
                    );
                  }
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
            style: GoogleFonts.openSans(fontSize: 14.sp, color: AppColors.red),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<PendingOrdersBloc>().add(
                const LoadPendingOrdersEvent(),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

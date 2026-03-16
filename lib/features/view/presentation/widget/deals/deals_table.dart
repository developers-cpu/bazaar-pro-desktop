import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/deals/deals.dart';
import '../../bloc/deals/deals_bloc.dart';
import '../../bloc/deals/deals_event.dart';
import '../../bloc/deals/deals_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'order_duration_dialog.dart';

class DealsTable extends StatelessWidget {
  final bool showDeviceInfo;
  final bool isDarkMode;
  const DealsTable({
    Key? key,
    this.showDeviceInfo = true,
    this.isDarkMode = false,
  }) : super(key: key);
  List<ViewTableColumn> _getColumns(bool isClient) {
    if (isClient) {
      return const [
        ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 130),
        ViewTableColumn(
          id: 'orderDateTime',
          label: 'Order D/T',
          width: 170,
          alignment: Alignment.centerRight,
        ),
        ViewTableColumn(id: 'buySell', label: 'B/S', width: 170),
        ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
        ViewTableColumn(id: 'lot', label: 'Lot', width: 70, isNumeric: true),
        ViewTableColumn(id: 'orderType', label: 'Type', width: 100),
        ViewTableColumn(id: 'pl', label: 'P/L', width: 90, isNumeric: true),
        ViewTableColumn(
          id: 'triggerPrice',
          label: 'T. PRICE',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'brokerage',
          label: 'Brk',
          width: 70,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'executionDateTime',
          label: 'Execution D/T',
          width: 170,
          alignment: Alignment.centerRight,
        ),
        ViewTableColumn(
          id: 'rPrice',
          label: 'R. PRICE',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'orderDuration',
          label: 'ORDER DURATION',
          width: 170,
        ),
      ];
    }
    final columns = <ViewTableColumn>[
      const ViewTableColumn(id: 'userName', label: 'U. NAME', width: 120),
      const ViewTableColumn(id: 'pUser', label: 'P USER', width: 120),
      const ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
      const ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 130),
      const ViewTableColumn(
        id: 'orderDateTime',
        label: 'ORDER D/T',
        width: 170,
        alignment: Alignment.centerRight,
      ),
      const ViewTableColumn(id: 'buySell', label: 'B/S', width: 170),
      const ViewTableColumn(
        id: 'qty',
        label: 'QTY',
        width: 80,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'lot',
        label: 'LOT',
        width: 70,
        isNumeric: true,
      ),
      const ViewTableColumn(id: 'orderType', label: 'TYPE', width: 100),
      const ViewTableColumn(id: 'pl', label: 'P/L', width: 90, isNumeric: true),
      const ViewTableColumn(
        id: 'triggerPrice',
        label: 'T. PRICE',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'brokerage',
        label: 'BRK',
        width: 70,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'executionDateTime',
        label: 'EXECUTION D/T',
        width: 170,
        alignment: Alignment.centerRight,
      ),
      const ViewTableColumn(
        id: 'rPrice',
        label: 'R. PRICE',
        width: 90,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'orderDuration',
        label: 'ORDER DURATION',
        width: 170,
      ),
    ];
    if (showDeviceInfo) {
      columns.addAll(const [
        ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 300),
        ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 120),
      ]);
    }
    return columns;
  }

  Widget _buildCell(
    BuildContext context,
    Deal item,
    ViewTableColumn column,
    bool isDark,
    bool isClient,
  ) {
    switch (column.id) {
      case 'userName':
        return ViewTextCell(text: item.userName, isDark: isDark);
      case 'pUser':
        return ViewTextCell(text: item.pUser, isDark: isDark);
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
      case 'orderDateTime':
        return ViewDateTimeCell(dateTime: item.orderDateTime, isDark: isDark);
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
          fixedColor: AppColors.primaryBlue,
          isDark: isDark,
        );
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          fixedColor: AppColors.primaryBlue,
          isDark: isDark,
        );
      case 'rPrice':
        return ViewNumberCell(
          value: item.rPrice,
          fixedColor: AppColors.primaryBlue,
          isDark: isDark,
        );
      case 'executionDateTime':
        return item.executionDateTime != null
            ? ViewDateTimeCell(
                dateTime: item.executionDateTime!,
                isDark: isDark,
              )
            : ViewTextCell(
                text: '-',
                isDark: isDark,
                alignment: Alignment.centerRight,
              );
      case 'orderDuration':
        return _buildOrderDurationCell(context, item, isDark, isClient);
      case 'deviceId':
        return ViewTextCell(text: item.deviceId ?? '-', isDark: isDark);
      case 'ipAddress':
        return ViewTextCell(text: item.ipAddress ?? '-', isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOrderDurationCell(
    BuildContext context,
    Deal item,
    bool isDark,
    bool isClient,
  ) {
    return GestureDetector(
      onTap: () {
        final state = context.read<DealsBloc>().state;
        if (state is DealsLoaded) {
          final relatedOrders = state.filteredDeals
              .where(
                (deal) =>
                    deal.symbol == item.symbol &&
                    deal.userName == item.userName,
              )
              .toList();
          OrderDurationDialog.show(
            context: context,
            relatedOrders: relatedOrders,
            isDarkMode: isDark,
          );
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.only(bottom: 2),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF2C5F7A), width: 2.0),
            ),
          ),
          child: Text(
            item.orderDuration,
            style: ViewTableCellStyles.getTextStyle(
              isDark: isDark,
              color: const Color(0xFF2C5F7A),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    return BlocBuilder<DealsBloc, DealsState>(
      builder: (context, state) {
        if (state is DealsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DealsError) {
          return _buildErrorState(context, state.message);
        }
        if (state is! DealsLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.totalRecords),
            Expanded(
              child: ViewDataTable<Deal>(
                autoFit: true,
                columns: _getColumns(isClient),
                data: state.filteredDeals,
                idExtractor: (item) => item.id,
                selectedId: state.selectedDealId,
                sortColumn: state.sortColumn,
                sortAscending: state.sortAscending,
                isDarkMode: isDarkMode,
                emptyMessage: 'No deals found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode, isClient),
                onRowTap: (item) {
                  context.read<DealsBloc>().add(SelectDealEvent(item.id));
                },
                onSort: (columnId, ascending) {
                  context.read<DealsBloc>().add(
                    SortDealsByColumnEvent(
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
              context.read<DealsBloc>().add(const LoadDealsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

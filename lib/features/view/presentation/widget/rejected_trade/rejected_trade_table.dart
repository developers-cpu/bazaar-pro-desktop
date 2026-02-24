import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/rejected_trade/rejected_trade.dart';
import '../../bloc/rejected_trade/rejected_trade_bloc.dart';
import '../../bloc/rejected_trade/rejected_trade_event.dart';
import '../../bloc/rejected_trade/rejected_trade_state.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class RejectedTradeTable extends StatelessWidget {
  const RejectedTradeTable({Key? key}) : super(key: key);

  static final List<ViewTableColumn> _columns = [
    const ViewTableColumn(id: 'userName', label: 'U. NAME', width: 100),
    const ViewTableColumn(id: 'parentUser', label: 'P USER', width: 100),
    const ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
    const ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
    const ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 170),
    const ViewTableColumn(id: 'buySell', label: 'B/S', width: 180),
    const ViewTableColumn(id: 'qty', label: 'QTY', width: 100, isNumeric: true),
    const ViewTableColumn(id: 'lot', label: 'LOT', width: 70, isNumeric: true),
    const ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
    const ViewTableColumn(id: 'pl', label: 'P/L', width: 100, isNumeric: true),
    const ViewTableColumn(
      id: 'tradePrice',
      label: 'T. PRICE',
      width: 110,
      isNumeric: true,
    ),
    const ViewTableColumn(
      id: 'brokerage',
      label: 'BRK',
      width: 80,
      isNumeric: true,
    ),
    const ViewTableColumn(
      id: 'ratePrice',
      label: 'R. PRICE',
      width: 100,
      isNumeric: true,
    ),
    const ViewTableColumn(
      id: 'executionDateTime',
      label: 'EXECUTION D/T',
      width: 170,
    ),
    const ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 280),
    const ViewTableColumn(id: 'city', label: 'CITY', width: 100),
    const ViewTableColumn(id: 'device', label: 'DEVICE', width: 80),
    const ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 120),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RejectedTradeBloc, RejectedTradeState>(
      builder: (context, state) {
        if (state is RejectedTradeLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (state is RejectedTradeError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          );
        }

        if (state is RejectedTradeLoaded) {
          return Column(
            children: [
              ViewRecordCount(count: state.totalRecords),
              Expanded(
                child: ViewDataTable<RejectedTrade>(
                  columns: _columns,
                  data: state.filteredTrades,
                  cellBuilder: _buildCell,
                  idExtractor: (trade) => trade.id,
                  onSort: (columnId, ascending) {
                    context.read<RejectedTradeBloc>().add(
                      SortRejectedTradesByColumnEvent(
                        columnId: columnId,
                        ascending: ascending,
                      ),
                    );
                  },
                  sortColumn: state.sortColumn,
                  sortAscending: state.sortAscending,
                  emptyMessage: 'No rejected trades found',
                  autoFit: true,
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCell(RejectedTrade trade, ViewTableColumn column) {
    switch (column.id) {
      case 'userName':
        return ViewTextCell(text: trade.userName);
      case 'parentUser':
        return ViewTextCell(text: trade.parentUser);
      case 'exchange':
        return ViewTextCell(text: trade.exchange);
      case 'symbol':
        return ViewTextCell(text: trade.symbol);
      case 'orderDateTime':
        return ViewDateTimeCell(dateTime: trade.orderDateTime);
      case 'buySell':
        return ViewBuySellCell(text: trade.buySell);
      case 'qty':
        return ViewNumberCell(value: trade.qty, colorByValue: false);
      case 'lot':
        return ViewNumberCell(value: trade.lot, colorByValue: false);
      case 'type':
        return ViewTextCell(text: trade.type);
      case 'pl':
        return ViewNumberCell(value: trade.pl, colorByValue: false);
      case 'tradePrice':
        return ViewNumberCell(value: trade.tradePrice, colorByValue: false);
      case 'brokerage':
        return ViewNumberCell(value: trade.brokerage, colorByValue: false);
      case 'ratePrice':
        return ViewNumberCell(value: trade.ratePrice, colorByValue: false);
      case 'executionDateTime':
        return ViewDateTimeCell(dateTime: trade.executionDateTime);
      case 'deviceId':
        return ViewTextCell(text: trade.deviceId);
      case 'city':
        return ViewTextCell(text: trade.city);
      case 'device':
        return ViewTextCell(text: trade.device);
      case 'ipAddress':
        return ViewTextCell(text: trade.ipAddress);
      default:
        return const ViewTextCell(text: '-');
    }
  }
}

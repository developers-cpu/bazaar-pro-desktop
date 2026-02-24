import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../domain/entities/rejection_log/rejection_log.dart';
import '../../bloc/rejection_log/rejection_log_bloc.dart';
import '../../bloc/rejection_log/rejection_log_event.dart';
import '../../bloc/rejection_log/rejection_log_state.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class RejectionLogTable extends StatelessWidget {
  const RejectionLogTable({Key? key}) : super(key: key);
  static final List<ViewTableColumn> _columns = [
    const ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 170),
    const ViewTableColumn(id: 'status', label: 'STATUS', width: 80),
    const ViewTableColumn(id: 'userName', label: 'U.NAME', width: 100),
    const ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 170),
    const ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
    const ViewTableColumn(id: 'qty', label: 'QTY', width: 100, isNumeric: true),
    const ViewTableColumn(
      id: 'price',
      label: 'PRICE',
      width: 100,
      isNumeric: true,
    ),
    const ViewTableColumn(id: 'comment', label: 'COMMENT', width: 400),
    const ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 280),
    const ViewTableColumn(id: 'device', label: 'DEVICE', width: 80),
    const ViewTableColumn(id: 'city', label: 'CITY', width: 100),
    const ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 120),
    const ViewTableColumn(id: 'date', label: 'DATE', width: 170),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RejectionLogBloc, RejectionLogState>(
      builder: (context, state) {
        if (state is RejectionLogLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        if (state is RejectionLogError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          );
        }
        if (state is RejectionLogLoaded) {
          return Column(
            children: [
              ViewRecordCount(count: state.totalRecords),
              Expanded(
                child: ViewDataTable<RejectionLog>(
                  columns: _columns,
                  data: state.filteredLogs,
                  cellBuilder: _buildCell,
                  idExtractor: (log) => log.id,
                  onSort: (columnId, ascending) {
                    context.read<RejectionLogBloc>().add(
                      SortRejectionLogsByColumnEvent(
                        columnId: columnId,
                        ascending: ascending,
                      ),
                    );
                  },
                  sortColumn: state.sortColumn,
                  sortAscending: state.sortAscending,
                  emptyMessage: 'No rejection logs found',
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

  Widget _buildCell(RejectionLog log, ViewTableColumn column) {
    switch (column.id) {
      case 'orderDateTime':
        return ViewDateTimeCell(dateTime: log.orderDateTime);
      case 'status':
        return ViewTextCell(text: log.status);
      case 'userName':
        return ViewTextCell(text: log.userName);
      case 'symbol':
        return ViewTextCell(text: log.symbol);
      case 'type':
        return ViewBuySellCell(text: log.type);
      case 'qty':
        return ViewNumberCell(value: log.qty, colorByValue: false);
      case 'price':
        return ViewNumberCell(value: log.price, colorByValue: false);
      case 'comment':
        return ViewTextCell(text: log.comment);
      case 'deviceId':
        return ViewTextCell(text: log.deviceId);
      case 'device':
        return ViewTextCell(text: log.device);
      case 'city':
        return ViewTextCell(text: log.city);
      case 'ipAddress':
        return ViewTextCell(text: log.ipAddress);
      case 'date':
        return ViewDateTimeCell(dateTime: log.date);
      default:
        return const ViewTextCell(text: '-');
    }
  }
}

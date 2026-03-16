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
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';

class RejectionLogTable extends StatelessWidget {
  const RejectionLogTable({Key? key}) : super(key: key);
  List<ViewTableColumn> _getColumns(bool isClient, bool isMaster) {
    if (isClient) {
      return const [
        ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 130),
        ViewTableColumn(id: 'exchange', label: 'EXCH', width: 100),
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 130),
        ViewTableColumn(id: 'type', label: 'B/S', width: 80),
        ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
        ViewTableColumn(
          id: 'price',
          label: 'PRICE',
          width: 80,
          isNumeric: true,
        ),
        ViewTableColumn(id: 'comment', label: 'COMMENT', width: 500),
      ];
    }

    return const [
      ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 170),
      ViewTableColumn(id: 'status', label: 'STATUS', width: 80),
      ViewTableColumn(id: 'userName', label: 'U.NAME', width: 80),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 130),
      ViewTableColumn(id: 'type', label: 'TYPE', width: 80),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
      ViewTableColumn(id: 'price', label: 'PRICE', width: 80, isNumeric: true),
      ViewTableColumn(id: 'comment', label: 'COMMENT', width: 450),
      ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 300),
      ViewTableColumn(id: 'device', label: 'DEVICE', width: 80),
      ViewTableColumn(id: 'city', label: 'CITY', width: 100),
      ViewTableColumn(
        id: 'ipAddress',
        label: 'IP ADDRESS',
        width: 120,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'date', label: 'DATE', width: 170),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isClient = false;
    bool isMaster = false;
    try {
      final authState = context.read<AuthBloc>().state;
      isClient =
          authState is AuthAuthenticated &&
          authState.user.role.toLowerCase() == 'client';
      isMaster =
          authState is AuthAuthenticated &&
          authState.user.role.toLowerCase() == 'master';
    } catch (_) {}
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
                  columns: _getColumns(isClient, isMaster),
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
      case 'exchange':
        return ViewTextCell(text: log.exchange);
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
        return ViewTextCell(text: log.ipAddress, isNumeric: true);
      case 'date':
        return ViewDateTimeCell(dateTime: log.date);
      default:
        return const ViewTextCell(text: '-');
    }
  }
}

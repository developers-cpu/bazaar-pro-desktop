import 'package:bazarpro/features/view/presentation/widget/common/view_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/rejection_log/rejection_log.dart';
import '../../bloc/rejection_log/rejection_log_bloc.dart';
import '../../bloc/rejection_log/rejection_log_event.dart';
import '../../bloc/rejection_log/rejection_log_state.dart';
import '../common/view_record_count.dart';
import '../common/view_table_cell_styles.dart';

class RejectionLogTable extends StatelessWidget {
  const RejectionLogTable({Key? key}) : super(key: key);
  static final List<ViewTableColumn> _columns = [
    const ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 140),
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
    const ViewTableColumn(id: 'comment', label: 'COMMENT', width: 300),
    const ViewTableColumn(id: 'date', label: 'DATE', width: 150),
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
      case 'date':
        return ViewDateTimeCell(dateTime: log.date, format: 'dd/MM/yy');
      default:
        return const ViewTextCell(text: '-');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/intraday_history/intraday_history.dart';
import '../../bloc/intraday_history/intraday_history_bloc.dart';
import '../../bloc/intraday_history/intraday_history_event.dart';
import '../../bloc/intraday_history/intraday_history_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class IntradaySecondsTable extends StatelessWidget {
  const IntradaySecondsTable({Key? key}) : super(key: key);
  static final List<ViewTableColumn> _columns = [
    const ViewTableColumn(id: 'timestamp', label: 'TIME STAMP', width: 100),
    const ViewTableColumn(
      id: 'open',
      label: 'OPEN',
      width: 150,
      isNumeric: true,
    ),
    const ViewTableColumn(
      id: 'high',
      label: 'HIGH',
      width: 150,
      isNumeric: true,
    ),
    const ViewTableColumn(id: 'low', label: 'LOW', width: 150, isNumeric: true),
    const ViewTableColumn(
      id: 'close',
      label: 'CLOSE',
      width: 150,
      isNumeric: true,
    ),
    const ViewTableColumn(
      id: 'volume',
      label: 'VOLUME',
      width: 150,
      isNumeric: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntradayHistoryBloc, IntradayHistoryState>(
      builder: (context, state) {
        if (state is IntradayHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        if (state is IntradayHistoryError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          );
        }
        if (state is IntradayHistorySecondsView) {
          return Column(
            children: [
              ViewRecordCount(count: state.totalRecords),
              Expanded(
                child: ViewDataTable<IntradayHistory>(
                  columns: _columns,
                  data: state.history,
                  cellBuilder: _buildCell,
                  idExtractor: (history) => history.id,
                  onSort: (columnId, ascending) {
                    context.read<IntradayHistoryBloc>().add(
                      SortIntradayByColumnEvent(
                        columnId: columnId,
                        ascending: ascending,
                      ),
                    );
                  },
                  sortColumn: state.sortColumn,
                  sortAscending: state.sortAscending,
                  emptyMessage: 'No seconds data found',
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

  Widget _buildCell(IntradayHistory history, ViewTableColumn column) {
    switch (column.id) {
      case 'timestamp':
        return ViewDateTimeCell(dateTime: history.timestamp);
      case 'open':
        return ViewNumberCell(value: history.open, colorByValue: false);
      case 'high':
        return ViewNumberCell(value: history.high, colorByValue: false);
      case 'low':
        return ViewNumberCell(value: history.low, colorByValue: false);
      case 'close':
        return ViewNumberCell(value: history.close, colorByValue: false);
      case 'volume':
        return ViewNumberCell(value: history.volume, colorByValue: false);
      default:
        return const ViewTextCell(text: '-');
    }
  }
}

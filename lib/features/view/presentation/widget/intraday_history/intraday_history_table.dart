import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/intraday_history.dart';
import '../../bloc/intraday_history/intraday_history_bloc.dart';
import '../../bloc/intraday_history/intraday_history_event.dart';
import '../../bloc/intraday_history/intraday_history_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../table/view_data_table.dart';
import '../table/view_record_count.dart';
import '../table/view_table_cell_styles.dart';

class IntradayHistoryTable extends StatelessWidget {
  const IntradayHistoryTable({Key? key}) : super(key: key);

  static final List<ViewTableColumn> _columns = [
    const ViewTableColumn(id: 'view', label: 'VIEW', width: 80, sortable: false),
    const ViewTableColumn(id: 'timestamp', label: 'TIME STAMP', width: 280),
    const ViewTableColumn(id: 'open', label: 'OPEN', width: 220, isNumeric: true),
    const ViewTableColumn(id: 'high', label: 'HIGH', width: 220, isNumeric: true),
    const ViewTableColumn(id: 'low', label: 'LOW', width: 220, isNumeric: true),
    const ViewTableColumn(id: 'close', label: 'CLOSE', width: 220, isNumeric: true),
    const ViewTableColumn(id: 'volume', label: 'VOLUME', width: 220, isNumeric: true),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntradayHistoryBloc, IntradayHistoryState>(
      builder: (context, state) {
        if (state is IntradayHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
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

        if (state is IntradayHistoryLoaded) {
          return Column(
            children: [
              ViewRecordCount(count: state.totalRecords),
              Expanded(
                child: ViewDataTable<IntradayHistory>(
                  columns: _columns,
                  data: state.history,
                  cellBuilder: (history, column) =>
                      _buildCell(context, history, column, state),
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
                  emptyMessage: 'No intraday history found',
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCell(
      BuildContext context,
      IntradayHistory history,
      ViewTableColumn column,
      IntradayHistoryLoaded state,
      ) {
    switch (column.id) {
      case 'view':
        return GestureDetector(
          onTap: () => _onViewTap(context, history, state),
          child: Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: AppColors.white,
              size: 18.sp,
            ),
          ),
        );

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

  void _onViewTap(
      BuildContext context,
      IntradayHistory history,
      IntradayHistoryLoaded state,
      ) {
    // Use selected date from state, or default to today
    final selectedDate = state.selectedDate ?? DateTime.now();

    // Set default time range (full day)
    final startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0);
    final endTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59);

    // Navigate directly to seconds view with all data
    context.read<IntradayHistoryBloc>().add(
      LoadSecondsDataEvent(
        date: selectedDate,
        exchange: state.selectedExchange ?? '',
        symbol: state.selectedSymbol ?? '',
        startTime: startTime,
        endTime: endTime,
      ),
    );
  }
}
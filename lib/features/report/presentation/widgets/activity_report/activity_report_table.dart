import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/activity_report.dart';
import '../../bloc/activity_report/activity_report_bloc.dart';
import '../../bloc/activity_report/activity_report_state.dart';
import 'activity_detail_dialogs.dart';

class ActivityReportTable extends StatelessWidget {
  final bool isDarkMode;
  const ActivityReportTable({super.key, this.isDarkMode = false});
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'activityName', label: 'ACTIVITY', width: 250),
      ViewTableColumn(id: 'createdOn', label: 'CREATED ON', width: 200),
      ViewTableColumn(id: 'createdBy', label: 'CREATED BY', width: 150),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    ActivityReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'activityName':
        return ViewLinkCell(
          text: item.activityName,
          isDark: isDark,
          onTap: () {
            
            _showDetailDialog(context, item);
          },
        );
      case 'createdOn':
        return ViewDateTimeCell(dateTime: item.createdOn, isDark: isDark);
      case 'createdBy':
        return ViewTextCell(text: item.createdBy, isDark: isDark);
      case 'updatedOn':
        return ViewDateTimeCell(dateTime: item.updatedOn, isDark: isDark);
      case 'updatedBy':
        return ViewTextCell(text: item.updatedBy, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showDetailDialog(BuildContext context, ActivityReport item) {
    ActivityDetailDialog.show(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityReportBloc, ActivityReportState>(
      builder: (context, state) {
        if (state is ActivityReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ActivityReportError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! ActivityReportLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Expanded(
              child: ViewDataTable<ActivityReport>(
                columns: _getColumns(),
                data: state.reports,
                idExtractor: (item) => item.id,
                sortColumn: null,
                sortAscending: true,
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No activity report found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode),
              ),
            ),
          ],
        );
      },
    );
  }
}

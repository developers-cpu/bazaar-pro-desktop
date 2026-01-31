import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../view/presentation/widget/common/view_record_count.dart';
import '../../../../view/presentation/widget/common/view_table_cell_styles.dart';
import '../../../domain/entities/activity_report.dart';
import '../../bloc/activity_report/activity_report_bloc.dart';
import '../../bloc/activity_report/activity_report_state.dart';

class ActivityReportTable extends StatelessWidget {
  final bool isDarkMode;

  const ActivityReportTable({super.key, this.isDarkMode = false});

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'userName', label: 'USER NAME', width: 150),
      ViewTableColumn(id: 'newEditUser', label: 'NEW EDIT USER', width: 150),
      ViewTableColumn(id: 'oldEditUser', label: 'OLD EDIT USER', width: 150),
      ViewTableColumn(id: 'newPhone', label: 'NEW PHONE', width: 150),
      ViewTableColumn(id: 'oldPhone', label: 'OLD PHONE', width: 150),
      ViewTableColumn(id: 'newGroupName', label: 'NEW GROUP NAME', width: 180),
      ViewTableColumn(id: 'oldGroupName', label: 'OLD GROUP NAME', width: 180),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 180),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150),
    ];
  }

  Widget _buildCell(ActivityReport item, ViewTableColumn column, bool isDark) {
    switch (column.id) {
      case 'userName':
        return ViewTextCell(text: item.userName, isDark: isDark);
      case 'newEditUser':
        return ViewTextCell(text: item.newEditUser ?? '', isDark: isDark);
      case 'oldEditUser':
        return ViewTextCell(text: item.oldEditUser ?? '', isDark: isDark);
      case 'newPhone':
        return ViewTextCell(text: item.newPhone ?? '', isDark: isDark);
      case 'oldPhone':
        return ViewTextCell(text: item.oldPhone ?? '', isDark: isDark);
      case 'newGroupName':
        return ViewTextCell(text: item.newGroupName ?? '', isDark: isDark);
      case 'oldGroupName':
        return ViewTextCell(text: item.oldGroupName ?? '', isDark: isDark);
      case 'updatedOn':
        return ViewDateTimeCell(dateTime: item.updatedOn, isDark: isDark);
      case 'updatedBy':
        return ViewTextCell(text: item.updatedBy, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
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
                isDarkMode: isDarkMode,
                emptyMessage: 'No activity report found',
                cellBuilder: (item, column) =>
                    _buildCell(item, column, isDarkMode),
              ),
            ),
          ],
        );
      },
    );
  }
}

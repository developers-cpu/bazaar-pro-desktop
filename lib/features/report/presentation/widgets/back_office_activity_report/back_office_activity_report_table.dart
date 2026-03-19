import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/back_office_activity_report.dart';
import '../../bloc/back_office_activity_report/back_office_activity_report_bloc.dart';
import '../../bloc/back_office_activity_report/back_office_activity_report_state.dart';
import 'back_office_activity_detail_dialog.dart';

class BackOfficeActivityReportTable extends StatelessWidget {
  final bool isDarkMode;
  const BackOfficeActivityReportTable({super.key, this.isDarkMode = false});

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(
        id: 'activityName',
        label: 'ACTIVITY',
        width: 150,
        alignment: Alignment.centerLeft,
      ),
      ViewTableColumn(id: 'createdOn', label: 'CREATED ON', width: 100),
      ViewTableColumn(id: 'createdBy', label: 'CREATED BY', width: 100),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 100),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    BackOfficeActivityReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'activityName':
        return ViewLinkCell(
          text: item.activityName,
          isDark: isDark,
          isStart: true,
          onTap: () {
            BackOfficeActivityDetailDialog.show(context, item);
          },
        );
      case 'createdOn':
        return ViewDateTimeCell(
          dateTime: item.createdOn,
          isDark: isDark,
          alignment: Alignment.center,
        );
      case 'createdBy':
        return ViewTextCell(
          text: item.createdBy,
          isDark: isDark,
          alignment: Alignment.center,
        );
      case 'updatedOn':
        return ViewDateTimeCell(
          dateTime: item.updatedOn,
          isDark: isDark,
          alignment: Alignment.center,
        );
      case 'updatedBy':
        return ViewTextCell(
          text: item.updatedBy,
          isDark: isDark,
          alignment: Alignment.center,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BackOfficeActivityReportBloc,
      BackOfficeActivityReportState
    >(
      builder: (context, state) {
        if (state is BackOfficeActivityReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BackOfficeActivityReportError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! BackOfficeActivityReportLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ViewDataTable<BackOfficeActivityReport>(
                  columns: _getColumns(),
                  data: state.reports,
                  idExtractor: (item) => item.id,
                  autoFit: true,
                  isDarkMode: isDarkMode,
                  emptyMessage: 'No back office activity report found',
                  cellBuilder: (item, column) =>
                      _buildCell(context, item, column, isDarkMode),
                  comparatorBuilder: (item, columnId) {
                    switch (columnId) {
                      case 'activityName':
                        return item.activityName;
                      case 'createdOn':
                        return item.createdOn;
                      case 'createdBy':
                        return item.createdBy;
                      case 'updatedOn':
                        return item.updatedOn;
                      case 'updatedBy':
                        return item.updatedBy;
                      default:
                        return '';
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
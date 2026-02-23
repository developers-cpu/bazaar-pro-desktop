import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../domain/entities/activity_report.dart';
import '../../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../../bloc/activity_detail/activity_detail_state.dart';

class GeneralDetailView extends StatelessWidget {
  final ActivityReport activity;
  final bool isDarkMode;
  const GeneralDetailView({
    super.key,
    required this.activity,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        'oldValue':
            activity.oldEditUser ??
            activity.oldGroupName ??
            activity.oldPhone ??
            '-',
        'newValue':
            activity.newEditUser ??
            activity.newGroupName ??
            activity.newPhone ??
            '-',
        'updatedOn': activity.updatedOn,
        'updatedBy': activity.updatedBy,
      },
    ];

    final columns = [
      const ViewTableColumn(id: 'oldValue', label: 'OLD VALUE', width: 220),
      const ViewTableColumn(id: 'newValue', label: 'NEW VALUE', width: 220),
      const ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 250),
      const ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 200),
    ];

    return BlocBuilder<ActivityDetailBloc, ActivityDetailState>(
      builder: (context, state) {
        final count = state is ActivityDetailLoaded ? state.recordCount : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ViewRecordCount(count: count),
            SizedBox(height: 10.h),
            SizedBox(
              height: 450.h,
              child: ViewDataTable<Map<String, dynamic>>(
                columns: columns,
                data: data,
                idExtractor: (item) => '1',
                isDarkMode: isDarkMode,
                autoFit: true,
                cellBuilder: (item, column) {
                  switch (column.id) {
                    case 'oldValue':
                    case 'newValue':
                    case 'updatedBy':
                      return ViewTextCell(
                        text: item[column.id],
                        isDark: isDarkMode,
                      );
                    case 'updatedOn':
                      return ViewDateTimeCell(
                        dateTime: item['updatedOn'],
                        isDark: isDarkMode,
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

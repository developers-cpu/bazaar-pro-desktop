import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../../bloc/activity_detail/activity_detail_state.dart';
class SimpleToggleDetailView extends StatelessWidget {
  final String oldLabel;
  final String newLabel;
  final String valueType;
  final bool isDarkMode;
  const SimpleToggleDetailView({
    super.key,
    required this.oldLabel,
    required this.newLabel,
    this.valueType = 'allowed',
    this.isDarkMode = false,
  });
  @override
  Widget build(BuildContext context) {
    final columns = [
      ViewTableColumn(id: 'old', label: oldLabel, width: 220),
      ViewTableColumn(id: 'new', label: newLabel, width: 220),
      const ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 250),
      const ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 150),
    ];
    return BlocBuilder<ActivityDetailBloc, ActivityDetailState>(
      builder: (context, state) {
        if (state is ActivityDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ActivityDetailError) {
          return Center(child: Text(state.message));
        }
        if (state is! ActivityDetailLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ViewRecordCount(count: state.recordCount),
            SizedBox(height: 10.h),
            SizedBox(
              height: 450.h,
              child: ViewDataTable<Map<String, dynamic>>(
                columns: columns,
                data: state.details,
                idExtractor: (item) => state.details.indexOf(item).toString(),
                isDarkMode: isDarkMode,
                autoFit: true,
                cellBuilder: (item, column) {
                  switch (column.id) {
                    case 'updatedOn':
                      return ViewDateTimeCell(
                        dateTime: item['updatedOn'],
                        isDark: isDarkMode,
                      );
                    default:
                      return ViewTextCell(
                        text: item[column.id].toString(),
                        isDark: isDarkMode,
                      );
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

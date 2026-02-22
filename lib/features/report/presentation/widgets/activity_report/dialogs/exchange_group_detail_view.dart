import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../../bloc/activity_detail/activity_detail_state.dart';

class ExchangeGroupDetailView extends StatelessWidget {
  final bool isDarkMode;
  const ExchangeGroupDetailView({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    final columns = [
      const ViewTableColumn(id: 'oldGroup', label: 'OLD GROUP', width: 220),
      const ViewTableColumn(id: 'newGroup', label: 'NEW GROUP', width: 220),
      const ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 250),
      const ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 200),
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
            Row(
              children: [
                SizedBox(
                  width: 200.w,
                  child: AppDropdown(
                    type: AppDropdownType.simple,
                    hintText: 'Exchange',
                    items: const ['NSE', 'MCX', 'COMEX'],
                    onChanged: (v) {},
                  ),
                ),
                const Spacer(),
                ViewRecordCount(count: state.recordCount),
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 420.h,
              child: ViewDataTable<Map<String, dynamic>>(
                columns: columns,
                data: state.details,
                idExtractor: (item) => item['newGroup'],
                isDarkMode: isDarkMode,
                autoFit: true,
                cellBuilder: (item, column) {
                  switch (column.id) {
                    case 'oldGroup':
                    case 'newGroup':
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

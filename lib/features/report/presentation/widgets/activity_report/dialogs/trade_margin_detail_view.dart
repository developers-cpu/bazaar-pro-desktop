import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../../bloc/activity_detail/activity_detail_state.dart';

class TradeMarginDetailView extends StatelessWidget {
  final bool isDarkMode;
  const TradeMarginDetailView({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    final columns = [
      const ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 110),
      const ViewTableColumn(
        id: 'oldA',
        label: 'OLD\nMARGIN (A)',
        width: 110,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'newA',
        label: 'NEW\nMARGIN (A)',
        width: 110,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'oldP',
        label: 'OLD\nMARGIN (%)',
        width: 110,
        isNumeric: true,
      ),
      const ViewTableColumn(
        id: 'newP',
        label: 'NEW\nMARGIN (%)',
        width: 110,
        isNumeric: true,
      ),
      const ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 230),
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
                idExtractor: (item) => item['exchange'],
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

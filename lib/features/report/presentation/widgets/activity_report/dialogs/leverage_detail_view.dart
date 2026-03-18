import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../../bloc/activity_detail/activity_detail_event.dart';
import '../../../bloc/activity_detail/activity_detail_state.dart';

class LeverageDetailView extends StatefulWidget {
  final bool isDarkMode;
  const LeverageDetailView({super.key, this.isDarkMode = false});
  @override
  State<LeverageDetailView> createState() => _LeverageDetailViewState();
}

class _LeverageDetailViewState extends State<LeverageDetailView> {
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final columns = [
      const ViewTableColumn(
        id: 'oldLeverage',
        label: 'OLD LEVERAGE',
        width: 220,
      ),
      const ViewTableColumn(
        id: 'newLeverage',
        label: 'NEW LEVERAGE',
        width: 220,
      ),
      const ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
      const ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100),
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
            _buildFilterBar(context),
            ViewRecordCount(count: state.recordCount),
            SizedBox(height: 10.h),
            Container(
              constraints: BoxConstraints(maxHeight: 410.h),
              child: ViewDataTable<Map<String, dynamic>>(
                columns: columns,
                data: state.details,
                idExtractor: (item) =>
                    item['updatedOn'].toString() + item['updatedBy'],
                isDarkMode: widget.isDarkMode,
                autoFit: true,
                comparatorBuilder: (item, columnId) {
                  final val = item[columnId];
                  if (val is num) return val;
                  if (val is DateTime) return val;
                  return val?.toString() ?? '';
                },
                cellBuilder: (item, column) {
                  switch (column.id) {
                    case 'oldLeverage':
                    case 'newLeverage':
                    case 'updatedBy':
                      return ViewTextCell(
                        text: item[column.id],
                        isDark: widget.isDarkMode,
                      );
                    case 'updatedOn':
                      return ViewDateTimeCell(
                        dateTime: item['updatedOn'],
                        isDark: widget.isDarkMode,
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

  Widget _buildFilterBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          DateRangePickerButton(
            width: 200.w,
            height: 35.h,
            selectedDateRange: _selectedDateRange,
            onTap: () {},
            onDateRangeSelected: (range) {
              setState(() => _selectedDateRange = range);
            },
          ),
          const Spacer(),
          ViewResetButtons(
            onReset: () {
              setState(() => _selectedDateRange = null);
              context.read<ActivityDetailBloc>().add(
                const FilterActivityDetails(),
              );
            },
            onView: () {
              context.read<ActivityDetailBloc>().add(
                FilterActivityDetails(dateRange: _selectedDateRange),
              );
            },
          ),
        ],
      ),
    );
  }
}

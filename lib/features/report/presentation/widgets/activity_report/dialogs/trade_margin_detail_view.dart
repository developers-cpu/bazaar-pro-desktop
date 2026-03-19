import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_tab_bar.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../bloc/activity_detail/activity_detail_bloc.dart';
import '../../../bloc/activity_detail/activity_detail_event.dart';
import '../../../bloc/activity_detail/activity_detail_state.dart';

class TradeMarginDetailView extends StatefulWidget {
  final bool isDarkMode;
  const TradeMarginDetailView({super.key, this.isDarkMode = false});
  @override
  State<TradeMarginDetailView> createState() => _TradeMarginDetailViewState();
}

class _TradeMarginDetailViewState extends State<TradeMarginDetailView> {
  DateTimeRange? _selectedDateRange;
  int _activeTab = 0;

  static const _tabs = ['Intraday Margin', 'Carry Forward Margin'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ViewTableColumn> _getColumns(bool isIntraday) {
    final prefix = isIntraday ? 'INT' : 'CF';
    return [
      const ViewTableColumn(id: 'exchange', label: 'EXCHANGE', width: 130),
      ViewTableColumn(
        id: 'oldA',
        label: 'OLD\n$prefix MARGIN (A)',
        width: 130,
        isNumeric: true,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'newA',
        label: 'NEW\n$prefix MARGIN (A)',
        width: 130,
        isNumeric: true,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'oldP',
        label: 'OLD\n$prefix MARGIN (%)',
        width: 130,
        isNumeric: true,
        headerLines: 2,
      ),
      ViewTableColumn(
        id: 'newP',
        label: 'NEW\n$prefix MARGIN (%)',
        width: 130,
        isNumeric: true,
        headerLines: 2,
      ),
      const ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 150),
      const ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 100),
    ];
  }

  Widget _buildTable(
    BuildContext context,
    List<Map<String, dynamic>> data,
    bool isIntraday,
  ) {
    final columns = _getColumns(isIntraday);
    return ViewDataTable<Map<String, dynamic>>(
      columns: columns,
      data: data,
      idExtractor: (item) => item['exchange'],
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
          case 'updatedOn':
            return ViewDateTimeCell(
              dateTime: item['updatedOn'],
              isDark: widget.isDarkMode,
            );
          default:
            return ViewTextCell(
              text: item[column.id]?.toString() ?? '-',
              isDark: widget.isDarkMode,
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        final intradayData = state.intradayDetails ?? [];
        final cfData = state.cfDetails ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterBar(context),
            _buildTabBar(),
            SizedBox(height: 8.h),
            ViewRecordCount(count: state.recordCount),
            SizedBox(height: 8.h),
            SizedBox(
              height: 390.h,
              child: _activeTab == 0
                  ? _buildTable(context, intradayData, true)
                  : _buildTable(context, cfData, false),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabBar() {
    return AppTabBar(
      tabs: _tabs.toList(),
      activeTab: _activeTab,
      onTabChanged: (i) => setState(() => _activeTab = i),
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
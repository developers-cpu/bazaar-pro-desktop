import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../bloc/users_bill_summary/users_bill_summary_bloc.dart';
import '../../bloc/users_bill_summary/users_bill_summary_event.dart';
import '../../bloc/users_bill_summary/users_bill_summary_state.dart';
import '../../../domain/entities/users_bill_summary/users_bill_summary_entity.dart';
import '../../../../../injection_container.dart';

class UsersBillSummaryDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: "User's Bill Summary",
      width: 900.w,
      showButtons: false,
      contentBuilder: (context, onClose) => BlocProvider(
        create: (context) =>
            sl<UsersBillSummaryBloc>()..add(GetUsersListEvent()),
        child: _UsersBillSummaryContent(onClose: onClose),
      ),
    );
  }
}

class _UsersBillSummaryContent extends StatelessWidget {
  final VoidCallback onClose;
  const _UsersBillSummaryContent({Key? key, required this.onClose})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBillSummaryBloc, UsersBillSummaryState>(
      builder: (context, state) {
        List<String> users = [];
        List<UsersBillSummaryEntity> summaryData = [];
        String? selectedUser;
        bool isLoading = state is UsersBillSummaryLoading;
        if (state is UsersBillSummaryUsersLoaded) {
          users = state.users;
        } else if (state is UsersBillSummaryDataLoaded) {
          users = state.users;
          summaryData = state.summaryData;
          selectedUser = state.selectedUser;
        } else if (state is UsersBillSummaryLoading) {
          users = state.users;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppDropdown(
                  hintText: 'Username',
                  type: AppDropdownType.search,
                  width: 200.w,
                  items: users,
                  value: selectedUser,
                  onChanged: (value) {
                    if (value != null && value.isNotEmpty) {
                      context.read<UsersBillSummaryBloc>().add(
                        GetUserBillSummaryEvent(value),
                      );
                    }
                  },
                ),
                if (summaryData.isNotEmpty)
                  ViewRecordCount(count: summaryData.length),
              ],
            ),
            SizedBox(height: 10.h),
            if (isLoading && summaryData.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Container(
                constraints: BoxConstraints(maxHeight: 480.h),
                child: ViewDataTable<UsersBillSummaryEntity>(
                  columns: _getColumns(),
                  data: summaryData,
                  autoFit: true,
                  comparatorBuilder: (item, columnId) {
                    switch (columnId) {
                      case 'puName':
                        return item.puName;
                      case 'uName':
                        return item.uName;
                      case 'netPL':
                        return item.netPL;
                      default:
                        return '';
                    }
                  },
                  rowHeight: 32.h,
                  idExtractor: (item) => "${item.puName}_${item.uName}",
                  cellBuilder: (item, column) =>
                      _buildCell(context, item, column),
                  footerBuilder: (columns) =>
                      _buildFooter(context, summaryData, columns),
                ),
              ),
          ],
        );
      },
    );
  }

  List<ViewTableColumn> _getColumns() {
    return [
      const ViewTableColumn(id: 'puName', label: 'P.U. NAME', width: 150),
      const ViewTableColumn(id: 'uName', label: 'U. NAME', width: 150),
      const ViewTableColumn(
        id: 'netPL',
        label: 'NET P/L',
        width: 150,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    UsersBillSummaryEntity item,
    ViewTableColumn column,
  ) {
    final isDark = AppColors.isDarkMode(context);
    if (column.id == 'netPL') {
      return ViewNumberCell(
        value: item.netPL,
        isDark: isDark,
        colorByValue: true,
      );
    }
    String text = "";
    if (column.id == 'puName') text = item.puName;
    if (column.id == 'uName') text = item.uName;
    return ViewTextCell(text: text, isDark: isDark);
  }

  Widget _buildFooter(
    BuildContext context,
    List<UsersBillSummaryEntity> data,
    List<ViewTableColumn> columns,
  ) {
    double totalPL = 0;
    for (var item in data) {
      totalPL += item.netPL;
    }
    final values = {
      'puName': 'TOTAL',
      'uName': '',
      'netPL': totalPL.toStringAsFixed(2),
    };
    final isDark = AppColors.isDarkMode(context);
    final columnColors = {
      'netPL': ViewTableCellStyles.getValueColor(totalPL, isDark: isDark),
    };
    return ViewDataTableFooter(
      columns: columns,
      values: values,
      columnColors: columnColors,
      isDarkMode: isDark,
    );
  }
}

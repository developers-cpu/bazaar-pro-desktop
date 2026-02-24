import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../bloc/users_bill_summary/users_bill_summary_bloc.dart';
import '../../bloc/users_bill_summary/users_bill_summary_event.dart';
import '../../bloc/users_bill_summary/users_bill_summary_state.dart';
import '../../../domain/entities/users_bill_summary/users_bill_summary_entity.dart';
import '../../../../../injection_container.dart';

class UsersBillSummaryDialog extends StatelessWidget {
  const UsersBillSummaryDialog({Key? key}) : super(key: key);
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (context) => BlocProvider(
        create: (context) =>
            sl<UsersBillSummaryBloc>()..add(GetUsersListEvent()),
        child: const UsersBillSummaryDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: "User's Bill Summary",
      width: 900.w,
      showButtons: false,
      content: BlocBuilder<UsersBillSummaryBloc, UsersBillSummaryState>(
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
                    hintText: 'Select User',
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
                    Text(
                      'RECORD : ${summaryData.length}',
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
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
                SizedBox(
                  height: 480.h,
                  child: ViewDataTable<UsersBillSummaryEntity>(
                    columns: _getColumns(),
                    data: summaryData,
                    autoFit: true,
                    rowHeight: 32.h,
                    idExtractor: (item) => "${item.puName}_${item.uName}",
                    cellBuilder: (item, column) => _buildCell(item, column),
                    footerBuilder: (columns) =>
                        _buildFooter(summaryData, columns),
                  ),
                ),
            ],
          );
        },
      ),
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

  Widget _buildCell(UsersBillSummaryEntity item, ViewTableColumn column) {
    if (column.id == 'netPL') {
      final isNegative = item.netPL < 0;
      return Text(
        item.netPL.toStringAsFixed(2),
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isNegative ? AppColors.errorColor : AppColors.primaryBlue,
        ),
      );
    }
    String text = "";
    if (column.id == 'puName') text = item.puName;
    if (column.id == 'uName') text = item.uName;
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildFooter(
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
    final columnColors = {
      'netPL': totalPL < 0 ? AppColors.errorColor : AppColors.primaryBlue,
    };
    return ViewDataTableFooter(
      columns: columns,
      values: values,
      columnColors: columnColors,
      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
    );
  }
}

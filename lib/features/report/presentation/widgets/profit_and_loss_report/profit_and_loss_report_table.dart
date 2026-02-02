import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../view/presentation/widget/common/view_record_count.dart';
import '../../../../view/presentation/widget/common/view_table_cell_styles.dart';
import '../../../../view/presentation/widget/common/view_data_table_footer.dart';
import '../../../../users/domain/entities/user.dart';
import '../../../../users/presentation/widgets/user_details/user_details_dialog.dart';
import '../../../domain/entities/profit_and_loss_report.dart';
import '../../bloc/profit_and_loss_report/profit_and_loss_report_bloc.dart';
import '../../bloc/profit_and_loss_report/profit_and_loss_report_state.dart';
import 'profit_and_loss_details_dialog.dart';

class ProfitAndLossReportTable extends StatelessWidget {
  final bool isDarkMode;

  const ProfitAndLossReportTable({super.key, this.isDarkMode = false});

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'view', label: 'VIEW', width: 60),
      ViewTableColumn(id: 'userName', label: 'U. NAME', width: 120),
      ViewTableColumn(id: 'percentage', label: '%', width: 80),
      ViewTableColumn(id: 'releasePL', label: 'RELEASE P/L', width: 120),
      ViewTableColumn(id: 'brokerage', label: 'BRK', width: 100),
      ViewTableColumn(id: 'm2m', label: 'M2M', width: 100),
      ViewTableColumn(id: 'netPL', label: 'NET P/L', width: 120),
      ViewTableColumn(id: 'ourBrokerage', label: 'OUR BRK', width: 120),
      ViewTableColumn(id: 'ourPercentage', label: 'OUR', width: 120),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    ProfitAndLossReport item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'view':
        return IconButton(
          icon: Icon(
            Icons.picture_in_picture_alt,
            size: 16.sp,
            color: const Color(0xFF1F4A66),
          ),
          onPressed: () {
            // Show details dialog (using same list for demo, ideally fetch details)
            ProfitAndLossDetailsDialog.show(context, [
              item,
              item,
            ], '${item.userName} 1');
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      case 'userName':
        return ViewLinkCell(
          text: item.userName,
          isDark: isDark,
          onTap: () {
            // Open User Details
            // Constructing a dummy user. In production, we'd fetch full user details.
            final dummyUser = User(
              id: item.id,
              userName: item.userName,
              name: item.userName,
              parentUser: '',
              type: 'Client',
              plPercent: 0,
              brkPercent: 0,
              leverage: '',
              credit: 0,
              pl: 0,
              equity: 0,
              totalMargin: 0,
              usedMargin: 0,
              freeMargin: 0,
              createdDate: DateTime.now(),
              status: 'Active',
            );
            UserDetailsDialog.show(context, dummyUser);
          },
        );
      case 'percentage':
        return ViewTextCell(
          text: item.percentage.toStringAsFixed(2),
          isDark: isDark,
        );
      case 'releasePL':
        return ViewTextCell(
          text: item.releasePL.toStringAsFixed(2),
          isDark: isDark,
          color: item.releasePL >= 0 ? Colors.blue : Colors.red,
        );
      case 'brokerage':
        return ViewNumberCell(
          value: item.brokerage,
          isDark: isDark,
          colorByValue: false,
        );
      case 'm2m':
        return ViewNumberCell(value: item.m2m, isDark: isDark);
      case 'netPL':
        return ViewNumberCell(value: item.netPL, isDark: isDark);
      case 'ourBrokerage':
        return ViewNumberCell(value: item.ourBrokerage, isDark: isDark);
      case 'ourPercentage':
        return ViewNumberCell(value: item.ourPercentage, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfitAndLossReportBloc, ProfitAndLossReportState>(
      builder: (context, state) {
        if (state is ProfitAndLossReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfitAndLossReportError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is! ProfitAndLossReportLoaded) {
          return const SizedBox.shrink();
        }

        double totalReleasePL = 0;
        double totalBrokerage = 0;
        double totalM2M = 0;
        double totalNetPL = 0;
        double totalOurBrokerage = 0;
        double totalOurPercentage = 0;

        for (var item in state.reports) {
          totalReleasePL += item.releasePL;
          totalBrokerage += item.brokerage;
          totalM2M += item.m2m;
          totalNetPL += item.netPL;
          totalOurBrokerage += item.ourBrokerage;
          totalOurPercentage += item.ourPercentage;
        }

        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Expanded(
              child: ViewDataTable<ProfitAndLossReport>(
                columns: _getColumns(),
                data: state.reports,
                idExtractor: (item) => item.id,
                sortColumn: null,
                sortAscending: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No records found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode),
                footerBuilder: (columns) {
                  return ViewDataTableFooter(
                    columns: columns,
                    values: {
                      'view': 'Total',
                      'releasePL': totalReleasePL.toStringAsFixed(2),
                      'brokerage': totalBrokerage.toStringAsFixed(2),
                      'm2m': totalM2M.toStringAsFixed(2),
                      'netPL': totalNetPL.toStringAsFixed(2),
                      'ourBrokerage': totalOurBrokerage.toStringAsFixed(2),
                      'ourPercentage': totalOurPercentage.toStringAsFixed(2),
                    },
                    isDarkMode: isDarkMode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

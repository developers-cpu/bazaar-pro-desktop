import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/profit_and_loss_report.dart';
import '../../../../view/presentation/widget/common/view_data_table.dart';
import '../../../../view/presentation/widget/common/view_table_cell_styles.dart';
import '../../../../view/presentation/widget/common/view_data_table_footer.dart';

class ProfitAndLossDetailsDialog extends StatelessWidget {
  final List<ProfitAndLossReport> reports;
  final String userName;

  const ProfitAndLossDetailsDialog({
    super.key,
    required this.reports,
    required this.userName,
  });

  static void show(
    BuildContext context,
    List<ProfitAndLossReport> reports,
    String userName,
  ) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) =>
          ProfitAndLossDetailsDialog(reports: reports, userName: userName),
    );
  }

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
        // Recursive view? Or just icon as per screenshot (maybe disabled for nested?)
        // In the screenshot, the nested dialog also has View icons.
        // For now, let's keep it but maybe do nothing or show a toast.
        return IconButton(
          icon: Icon(
            Icons.picture_in_picture_alt,
            size: 16.sp,
            color: const Color(0xFF1F4A66),
          ),
          onPressed: () {
            // Maybe open another dialog or similar
          },
        );
      case 'userName':
        return ViewLinkCell(
          text: item.userName,
          isDark: isDark,
          onTap: () {
            // Can open User Details here too
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
    double totalReleasePL = 0;
    double totalBrokerage = 0;
    double totalM2M = 0;
    double totalNetPL = 0;
    double totalOurBrokerage = 0;
    double totalOurPercentage = 0;

    for (var item in reports) {
      totalReleasePL += item.releasePL;
      totalBrokerage += item.brokerage;
      totalM2M += item.m2m;
      totalNetPL += item.netPL;
      totalOurBrokerage += item.ourBrokerage;
      totalOurPercentage += item.ourPercentage;
    }

    return CommonDialog(
      title: 'Profit & Loss',
      width: 1000.w,
      height: 600.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.greyBorder)),
              ),
              child: Text(
                userName,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F4A66),
                ),
              ),
            ),
            Expanded(
              child: ViewDataTable<ProfitAndLossReport>(
                columns: _getColumns(),
                data: reports,
                idExtractor: (item) => item.id,
                emptyMessage: 'No records found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, false),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

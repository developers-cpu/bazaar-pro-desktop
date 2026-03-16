import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/svg_icon.dart';
import '../../../domain/entities/settlement_report.dart';

class SettlementReportView extends StatelessWidget {
  final SettlementReport report;
  final Function(String userId, String username) onUserSelected;
  const SettlementReportView({
    super.key,
    required this.report,
    required this.onUserSelected,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTable(
                title: 'PROFIT',
                headerColor: AppColors.buyColor,
                entries: report.profitList,
                total: report.profitTotal,
                isProfitSection: true,
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: _buildTable(
                title: 'LOSS',
                headerColor: AppColors.sellColor,
                entries: report.lossList,
                total: report.lossTotal,
                isProfitSection: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable({
    required String title,
    required Color headerColor,
    required List<SettlementEntry> entries,
    required SettlementTotal total,
    required bool isProfitSection,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: headerColor, width: 1.0),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.r),
                topRight: Radius.circular(3.r),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildHeaderText('Username', alignLeft: true),
                ),
                Expanded(flex: 2, child: _buildHeaderText('P&L')),
                Expanded(flex: 2, child: _buildHeaderText('Brk')),
                Expanded(
                  flex: 2,
                  child: _buildHeaderText('Total', alignRight: true),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                ...entries.asMap().entries.map(
                  (e) => _buildRow(e.value, isProfitSection, e.key),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Total',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            color: AppColors.billDataText,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          total.totalPnl.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 13.sp,
                            color: AppColors.billDataText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          total.totalBrokerage.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 13.sp,
                            color: AppColors.billDataText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          total.totalAmount.toStringAsFixed(0),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.openSans(
                            fontSize: 13.sp,
                            color: isProfitSection
                                ? AppColors.buyColor
                                : AppColors.sellColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(
    String text, {
    bool alignLeft = false,
    bool alignRight = false,
  }) {
    MainAxisAlignment alignment = MainAxisAlignment.center;
    if (alignLeft) alignment = MainAxisAlignment.start;
    if (alignRight) alignment = MainAxisAlignment.end;
    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: GoogleFonts.openSans(
            color: AppColors.billTableHeaderText,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(width: 4.w),
        SvgIcon(assetPath: AppImages.sortIcon, isActive: false, size: 12.sp),
      ],
    );
  }

  Widget _buildRow(SettlementEntry entry, bool isProfitSection, int index) {
    final isMaster = entry.userType.toUpperCase() != 'C';
    final rowContent = Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? (isProfitSection
                  ? AppColors.headerBgColor
                  : LightThemeColors.chipBgRed)
            : Colors.transparent,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  entry.username,
                  style: GoogleFonts.openSans(
                    color: AppColors.billDataText,
                    fontSize: 13.sp,
                    decoration: isMaster ? TextDecoration.underline : null,
                    decorationColor: AppColors.billDataText,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '[ ${entry.userType} ]',
                  style: GoogleFonts.openSans(
                    color: AppColors.billDataText,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              entry.pnl.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                color: AppColors.billDataText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              entry.brokerage.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                color: AppColors.billDataText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              entry.total.toStringAsFixed(0),
              textAlign: TextAlign.right,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                color: isProfitSection
                    ? AppColors.buyColor
                    : AppColors.sellColor,
              ),
            ),
          ),
        ],
      ),
    );
    if (isMaster) {
      return InkWell(
        onTap: () => onUserSelected(
          entry.userId,
          '${entry.username} [ ${entry.userType} ]',
        ),
        child: rowContent,
      );
    }
    return rowContent;
  }
}

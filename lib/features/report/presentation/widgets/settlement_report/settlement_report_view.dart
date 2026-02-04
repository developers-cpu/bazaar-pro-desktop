import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
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
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTable(
              title: 'PROFIT',
              headerColor: AppColors.billBuyColor, 
              entries: report.profitList,
              total: report.profitTotal,
              isProfitSection: true,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildTable(
              title: 'LOSS',
              headerColor: AppColors.billLossColor, 
              entries: report.lossList,
              total: report.lossTotal,
              isProfitSection: false,
            ),
          ),
        ],
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
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: headerColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.r),
              topRight: Radius.circular(4.r),
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
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              ...entries.map((entry) => _buildRow(entry, isProfitSection)),

              const Divider(height: 1),

              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildHeaderText('Total', alignLeft: true),
                    ), 
                    Expanded(
                      flex: 2,
                      child: Text(
                        total.totalPnl.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isProfitSection
                              ? AppColors.billBuyColor
                              : AppColors.billLossColor,
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
                          fontWeight: FontWeight.bold,
                          color: isProfitSection
                              ? AppColors.billBuyColor
                              : AppColors.billLossColor,
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
                          fontWeight: FontWeight.bold,
                          color: isProfitSection
                              ? AppColors.billBuyColor
                              : AppColors.billLossColor,
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
    );
  }

  Widget _buildHeaderText(
    String text, {
    bool alignLeft = false,
    bool alignRight = false,
  }) {
    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : (alignRight ? TextAlign.right : TextAlign.center),
      style: GoogleFonts.openSans(
        color: AppColors.billTableHeaderText,
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
      ),
    );
  }

  Widget _buildRow(SettlementEntry entry, bool isProfitSection) {
    return InkWell(
      onTap: () => onUserSelected(entry.userId, entry.username),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
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
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '[ ${entry.userType} ]',
                    style: GoogleFonts.openSans(
                      color: AppColors.billTableHeaderText,
                      fontSize: 12.sp,
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
                  fontWeight: FontWeight.bold,
                  color: isProfitSection
                      ? AppColors.billBuyColor
                      : AppColors.billLossColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

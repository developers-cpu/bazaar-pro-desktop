import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/settlement_report.dart';
import '../shared/shared_settlement_table.dart';

class SettlementReportView extends StatelessWidget {
  final SettlementReport report;
  final Function(String userId, String username) onUserSelected;
  final bool isDrilledDown;

  const SettlementReportView({
    super.key,
    required this.report,
    required this.onUserSelected,
    this.isDrilledDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SharedSettlementTable<SettlementEntry>(
              title: 'PROFIT',
              headerColor: AppColors.buyColor,
              entries: report.profitList,
              isProfitSection: true,
              showTotalColumn: true,
              isDrilledDown: isDrilledDown,
              pnlColumnName: 'P&L',
              middleColumnName: 'Brk',
              getUserId: (e) => e.userId,
              getUsername: (e) => e.username,
              getUserType: (e) => e.userType,
              getPnl: (e) => e.pnl,
              getMiddleValue: (e) => e.brokerage,
              getTotal: (e) => e.total,
              onUserSelected: onUserSelected,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: SharedSettlementTable<SettlementEntry>(
              title: 'LOSS',
              headerColor: AppColors.sellColor,
              entries: report.lossList,
              isProfitSection: false,
              showTotalColumn: true,
              isDrilledDown: isDrilledDown,
              pnlColumnName: 'P&L',
              middleColumnName: 'Brk',
              getUserId: (e) => e.userId,
              getUsername: (e) => e.username,
              getUserType: (e) => e.userType,
              getPnl: (e) => e.pnl,
              getMiddleValue: (e) => e.brokerage,
              getTotal: (e) => e.total,
              onUserSelected: onUserSelected,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/settlement_sharing_report.dart';
import '../shared/shared_settlement_table.dart';

class SettlementSharingReportView extends StatelessWidget {
  final SettlementSharingReport report;
  final Function(String userId, String username) onUserSelected;
  final bool isDrilledDown;

  const SettlementSharingReportView({
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
            child: SharedSettlementTable<SettlementSharingEntry>(
              title: 'PROFIT',
              headerColor: AppColors.buyColor,
              entries: report.profitList,
              isProfitSection: true,
              showTotalColumn: true,
              isDrilledDown: isDrilledDown,
              pnlColumnName: 'Net P&L',
              middleColumnName: '% Wise',
              getUserId: (e) => e.userId,
              getUsername: (e) => e.username,
              getUserType: (e) => e.userType,
              getPnl: (e) => e.pnl,
              getMiddleValue: (e) => e.percentWise,
              getTotal: (e) => e.total,
              onUserSelected: onUserSelected,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: SharedSettlementTable<SettlementSharingEntry>(
              title: 'LOSS',
              headerColor: AppColors.sellColor,
              entries: report.lossList,
              isProfitSection: false,
              showTotalColumn: true,
              isDrilledDown: isDrilledDown,
              pnlColumnName: 'Net P&L',
              middleColumnName: '% Wise',
              getUserId: (e) => e.userId,
              getUsername: (e) => e.username,
              getUserType: (e) => e.userType,
              getPnl: (e) => e.pnl,
              getMiddleValue: (e) => e.percentWise,
              getTotal: (e) => e.total,
              onUserSelected: onUserSelected,
            ),
          ),
        ],
      ),
    );
  }
}

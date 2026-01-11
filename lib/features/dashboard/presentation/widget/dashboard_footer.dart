import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Dashboard Footer Widget showing P/L, BK, OTHER, BALANCE
class DashboardFooter extends StatelessWidget {
  final DashboardSummary summary;

  const DashboardFooter({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: LightThemeColors.tableColumnHeadColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSummaryItem('P/L', summary.pnl),
          _buildDivider(),
          _buildSummaryItem('BK', summary.bk),
          _buildDivider(),
          _buildSummaryItem('OTHER', summary.other),
          _buildDivider(),
          _buildSummaryItem('BALANCE', summary.balance),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        '$label: ${_formatNumber(value)}',
        style: GoogleFonts.openSans(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: LightThemeColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 20.h,
      color: LightThemeColors.primaryColor.withOpacity(0.3),
    );
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }
}
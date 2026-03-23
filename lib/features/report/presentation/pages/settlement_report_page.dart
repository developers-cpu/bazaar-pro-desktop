import 'package:bazarpro/features/report/presentation/bloc/settlement_report/settlement_report_bloc.dart'
    show SettlementReportBloc;
import 'package:bazarpro/features/report/presentation/bloc/settlement_report/settlement_report_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/settlement_report/settlement_report_state.dart';
import '../widgets/settlement_report/settlement_filter_bar.dart';
import '../widgets/settlement_report/settlement_report_view.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../widgets/settlement_report/settlement_detail_dialog.dart';

class SettlementReportPage extends StatelessWidget {
  const SettlementReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementReportBloc, SettlementReportState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state is SettlementReportLoaded)
                SettlementFilterBar(
                  onDateRangeChanged: (value) {
                    if (value != null) {
                      context.read<SettlementReportBloc>().add(
                        LoadSettlementReport(
                          dateRange: value,
                          userId: state.selectedUserId,
                        ),
                      );
                    }
                  },
                  onReset: () {
                    context.read<SettlementReportBloc>().add(
                      LoadSettlementReport(dateRange: 'This Week'),
                    );
                  },
                  onView: () {
                    context.read<SettlementReportBloc>().add(
                      LoadSettlementReport(
                        dateRange: state.selectedDateRange,
                        userId: state.selectedUserId,
                      ),
                    );
                  },
                ),
              if (state is SettlementReportLoaded)
                Builder(
                  builder: (context) {
                    final netPnl =
                        state.report.profitTotal.totalPnl +
                        state.report.lossTotal.totalPnl;
                    final isNegative = netPnl < 0;
                    final color = isNegative
                        ? AppColors.sellColor
                        : AppColors.buyColor;
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: color, width: 1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: AppColors.primaryBlue,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.arrow_downward,
                                color: AppColors.sellColor,
                                size: 14.sp,
                              ),
                            ],
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'P&L',
                            style: GoogleFonts.openSans(
                              color: AppColors.billDataText,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              netPnl.toStringAsFixed(0),
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state is SettlementReportLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SettlementReportLoaded) {
                      return SettlementReportView(
                        report: state.report,
                        onUserSelected: (userId, username) {
                          SettlementDetailDialog.show(
                            context,
                            userId,
                            username,
                            state.selectedDateRange,
                          );
                        },
                      );
                    } else if (state is SettlementReportError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

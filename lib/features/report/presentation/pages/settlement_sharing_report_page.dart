import 'package:bazarpro/features/report/presentation/bloc/settlement_sharing_report/settlement_sharing_report_bloc.dart'
    show SettlementSharingReportBloc;
import 'package:bazarpro/features/report/presentation/bloc/settlement_sharing_report/settlement_sharing_report_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../injection_container.dart';
import '../bloc/settlement_sharing_report/settlement_sharing_report_state.dart';
import '../widgets/settlement_sharing_report/settlement_sharing_filter_bar.dart';
import '../widgets/settlement_sharing_report/settlement_sharing_report_view.dart';
import '../../../../../../core/constants/app_colors.dart';

class SettlementSharingReportPage extends StatelessWidget {
  const SettlementSharingReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SettlementSharingReportBloc>()..add(LoadSettlementSharingReport()),
      child:
          BlocBuilder<
            SettlementSharingReportBloc,
            SettlementSharingReportState
          >(
            builder: (context, state) {
              final isDrilledDown =
                  state is SettlementSharingReportLoaded &&
                  state.selectedUserId != null;
              return PopScope(
                canPop: !isDrilledDown,
                onPopInvoked: (didPop) {
                  if (didPop) return;
                  if (isDrilledDown) {
                    context.read<SettlementSharingReportBloc>().add(
                      ClearSelectedUser(),
                    );
                  }
                },
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is SettlementSharingReportLoaded &&
                          state.selectedUserId != null)
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, top: 8.h),
                          child: InkWell(
                            onTap: () {
                              context.read<SettlementSharingReportBloc>().add(
                                ClearSelectedUser(),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: AppColors.billDataText,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Settlement With % Sharing',
                                  style: GoogleFonts.openSans(
                                    color: AppColors.billTableHeaderText,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (state is SettlementSharingReportLoaded)
                        SettlementSharingFilterBar(
                          selectedDateRange: state.selectedDateRange,
                          onDateRangeChanged: (value) {
                            if (value != null) {
                              context.read<SettlementSharingReportBloc>().add(
                                LoadSettlementSharingReport(
                                  dateRange: value,
                                  userId: state.selectedUserId,
                                ),
                              );
                            }
                          },
                          onReset: () {
                            context.read<SettlementSharingReportBloc>().add(
                              LoadSettlementSharingReport(
                                dateRange: 'This Week',
                              ),
                            );
                          },
                          onView: () {
                            context.read<SettlementSharingReportBloc>().add(
                              LoadSettlementSharingReport(
                                dateRange: state.selectedDateRange,
                                userId: state.selectedUserId,
                              ),
                            );
                          },
                        ),
                      if (state is SettlementSharingReportLoaded)
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
                      if (state is SettlementSharingReportLoaded &&
                          state.selectedUserId != null &&
                          state.selectedUserName != null)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 16.w,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.billTableHeaderText,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            state.selectedUserName!,
                            style: GoogleFonts.openSans(
                              color: AppColors.sellColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if (state is SettlementSharingReportLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is SettlementSharingReportLoaded) {
                              return SettlementSharingReportView(
                                report: state.report,
                                isDrilledDown: state.selectedUserId != null,
                                onUserSelected: (userId, username) {
                                  context
                                      .read<SettlementSharingReportBloc>()
                                      .add(
                                        SelectUserForDetail(
                                          userId: userId,
                                          username: username,
                                        ),
                                      );
                                },
                              );
                            } else if (state is SettlementSharingReportError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}

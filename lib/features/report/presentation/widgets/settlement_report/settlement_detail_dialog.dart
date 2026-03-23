import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/table/table_export_service.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/animated_export_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../injection_container.dart';
import '../../bloc/settlement_report/settlement_report_bloc.dart';
import '../../bloc/settlement_report/settlement_report_event.dart';
import '../../bloc/settlement_report/settlement_report_state.dart';
import '../../../domain/entities/settlement_report.dart';
import '../settlement_sharing_report/settlement_sharing_filter_bar.dart';
import 'settlement_report_view.dart';

class SettlementDetailDialog {
  static void show(
    BuildContext context,
    String userId,
    String userName,
    String dateRange,
  ) {
    final bloc = sl<SettlementReportBloc>()
      ..add(LoadSettlementReport(dateRange: dateRange, userId: userId));

    CommonDialog.show(
      context: context,
      title: 'Settlement User: $userName',
      width: 1100.w,
      height: 800.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      onClose: () => bloc.close(),
      titleActions: [
        AnimatedExportButton(
          onExportPdf: () {
            final state = bloc.state;
            if (state is SettlementReportLoaded) {
              final allEntries = [
                ...state.report.profitList,
                ...state.report.lossList,
              ];
              TableExportService.exportAsPdf(
                title: 'Settlement User: ${state.selectedUserName ?? userName}',
                columns: _getExportColumns(),
                data: allEntries,
                cellValueExtractor: _exportValueExtractor,
              );
            }
          },
          onExportExcel: () {
            final state = bloc.state;
            if (state is SettlementReportLoaded) {
              final allEntries = [
                ...state.report.profitList,
                ...state.report.lossList,
              ];
              TableExportService.exportAsExcel(
                title: 'Settlement User: ${state.selectedUserName ?? userName}',
                columns: _getExportColumns(),
                data: allEntries,
                cellValueExtractor: _exportValueExtractor,
              );
            }
          },
        ),
      ],
      contentBuilder: (dialogContext, onClose) {
        return BlocProvider.value(
          value: bloc,
          child: const _SettlementDetailDialogContent(),
        );
      },
    );
  }

  static List<ViewTableColumn> _getExportColumns() {
    return const [
      ViewTableColumn(id: 'username', label: 'USERNAME', width: 150),
      ViewTableColumn(id: 'pnl', label: 'P&L', width: 100, isNumeric: true),
      ViewTableColumn(
        id: 'brokerage',
        label: 'Brk',
        width: 100,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'total', label: 'TOTAL', width: 100, isNumeric: true),
    ];
  }

  static String _exportValueExtractor(dynamic e, ViewTableColumn col) {
    if (e is! SettlementEntry) return '-';
    switch (col.id) {
      case 'username':
        return '${e.username} [${e.userType}]';
      case 'pnl':
        return e.pnl.toStringAsFixed(0);
      case 'brokerage':
        return e.brokerage.toStringAsFixed(0);
      case 'total':
        return e.total.toStringAsFixed(0);
      default:
        return '-';
    }
  }
}

class _SettlementDetailDialogContent extends StatelessWidget {
  const _SettlementDetailDialogContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementReportBloc, SettlementReportState>(
      builder: (context, state) {
        if (state is SettlementReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SettlementReportError) {
          return Center(child: Text(state.message));
        } else if (state is SettlementReportLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettlementSharingFilterBar(
                onDateRangeChanged: (val) {
                  if (val != null) {
                    context.read<SettlementReportBloc>().add(
                      LoadSettlementReport(
                        dateRange: val,
                        userId: state.selectedUserId,
                      ),
                    );
                  }
                },
                onReset: () {
                  context.read<SettlementReportBloc>().add(
                    LoadSettlementReport(
                      dateRange: 'This Week',
                      userId: state.selectedUserId,
                    ),
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

              _buildPnlSummary(state),

              if (state.selectedUserName != null)
                _buildUserNameCard(state.selectedUserName!),

              Expanded(
                child: SettlementReportView(
                  report: state.report,
                  isDrilledDown: state.selectedUserId != null,
                  onUserSelected: (id, name) {
                    context.read<SettlementReportBloc>().add(
                      SelectUserForDetail(userId: id, username: name),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPnlSummary(SettlementReportLoaded state) {
    final netPnl =
        state.report.profitTotal.totalPnl + state.report.lossTotal.totalPnl;
    final isNegative = netPnl < 0;
    final color = isNegative ? AppColors.sellColor : AppColors.buyColor;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_upward, color: AppColors.primaryBlue, size: 14.sp),
          SizedBox(width: 4.w),
          Icon(Icons.arrow_downward, color: AppColors.sellColor, size: 14.sp),
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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
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
  }

  Widget _buildUserNameCard(String userName) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.billTableHeaderText),
        borderRadius: BorderRadius.circular(4.r),
      ),
      alignment: Alignment.center,
      child: Text(
        userName,
        style: GoogleFonts.openSans(
          color: AppColors.sellColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

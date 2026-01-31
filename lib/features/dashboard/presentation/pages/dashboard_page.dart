import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widget/dashboard_footer.dart';
import '../widget/report_card.dart';
import '../widget/symbol_wise_chart.dart';
import '../widget/trade_reports_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const LoadDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return const _DashboardView();
  }
}

class DashboardPageWithAppBar extends StatelessWidget {
  const DashboardPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarSection(
        selectedTabIndex: 1, 
        onTabSelected: (_) {},
        showExportByDefault: false,
      ),
      body: const DashboardPage(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LightThemeColors.backgroundColor,
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoading();
          }

          if (state is DashboardError) {
            return _buildError(state.message);
          }

          if (state is DashboardLoaded) {
            return _buildContent(context, state);
          }

          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: LightThemeColors.primaryColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading Dashboard...',
            style: GoogleFonts.openSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: LightThemeColors.supportiveTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: AppColors.errorColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading dashboard',
            style: GoogleFonts.openSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: LightThemeColors.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              color: LightThemeColors.supportiveTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
          child: Text(
            'Dashboard',
            style: GoogleFonts.openSans(
              fontSize: 22.sp,
              color: LightThemeColors.textColor,
            ),
          ),
        ),

        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 1400.w,
                maxHeight: 500.h,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 750.w,
                          maxHeight: 700.h,
                        ),
                        child: ReportCard(
                          title: 'Trade Reports',
                          chart: TradeReportsChart(data: state.tradeReports),
                          clients: state.clients,
                          selectedClient: state.tradeReportClientId,
                          onClientChanged: (client) {
                            context.read<DashboardBloc>().add(
                              FilterTradeReportsByClientEvent(clientId: client),
                            );
                          },
                          periods: state.periods,
                          selectedPeriod: state.tradeReportPeriod,
                          onPeriodChanged: (period) {
                            if (period != null) {
                              context.read<DashboardBloc>().add(
                                FilterTradeReportsByPeriodEvent(period: period),
                              );
                            }
                          },
                          exchanges: state.exchanges,
                          selectedExchanges: state.tradeReportSelectedExchanges,
                          onExchangeToggle: (exchange) {
                            context.read<DashboardBloc>().add(
                              ToggleTradeReportExchangeEvent(exchange: exchange),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),

                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 750.w,
                          maxHeight: 700.h,
                        ),
                        child: ReportCard(
                          title: 'Symbol Wise Report',
                          chart: SymbolWiseChart(data: state.symbolReports),
                          clients: state.clients,
                          selectedClient: state.symbolReportClientId,
                          onClientChanged: (client) {
                            context.read<DashboardBloc>().add(
                              FilterSymbolReportsByClientEvent(clientId: client),
                            );
                          },
                          periods: state.periods,
                          selectedPeriod: state.symbolReportPeriod,
                          onPeriodChanged: (period) {
                            if (period != null) {
                              context.read<DashboardBloc>().add(
                                FilterSymbolReportsByPeriodEvent(period: period),
                              );
                            }
                          },
                          exchanges: state.exchanges,
                          selectedExchanges: state.symbolReportSelectedExchanges,
                          onExchangeToggle: (exchange) {
                            context.read<DashboardBloc>().add(
                              ToggleSymbolReportExchangeEvent(exchange: exchange),
                            );
                          },
                          topCounts: state.topCounts,
                          selectedTopCount: state.symbolReportTopCount,
                          onTopCountChanged: (topCount) {
                            if (topCount != null) {
                              context.read<DashboardBloc>().add(
                                ChangeSymbolReportTopCountEvent(
                                  topCount: int.parse(topCount),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),
        DashboardFooter(summary: state.summary),
        SizedBox(height: 8.h),
      ],
    );
  }
}
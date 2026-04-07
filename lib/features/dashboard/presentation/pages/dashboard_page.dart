import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widget/report_card.dart';
import '../widget/symbol_wise_chart.dart';
import '../widget/trade_reports_chart.dart';
import '../widget/weekly_progress_chart.dart';

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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? userRole;
        if (state is AuthAuthenticated) {
          userRole = state.user.role;
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBarSection(
            selectedTabIndex: 1,
            userRole: userRole,
            onTabSelected: (_) {},
            showExportByDefault: false,
          ),
          body: const DashboardPage(),
        );
      },
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
            final authState = context.read<AuthBloc>().state;
            String? userRole;
            if (authState is AuthAuthenticated) {
              userRole = authState.user.role;
            }
            return _buildContent(context, state, userRole);
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
          CircularProgressIndicator(color: LightThemeColors.primaryColor),
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
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.errorColor),
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

  Widget _buildContent(
    BuildContext context,
    DashboardLoaded state,
    String? userRole,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final topCardHeight = isWide ? constraints.maxHeight * 0.52 : 350.0;
        final weeklyCardHeight = constraints.maxHeight * 0.35;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 6.h),
                child: Text(
                  'Dashboard',
                  style: GoogleFonts.openSans(
                    fontSize: 18.sp,
                    color: LightThemeColors.textColor,
                  ),
                ),
              ),
              if (isWide)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: SizedBox(
                    height: topCardHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildTradeReportsCard(
                            context,
                            state,
                            userRole,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _buildSymbolWiseCard(context, state, userRole),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: SizedBox(
                    height: topCardHeight,
                    child: _buildTradeReportsCard(context, state, userRole),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: SizedBox(
                    height: topCardHeight,
                    child: _buildSymbolWiseCard(context, state, userRole),
                  ),
                ),
              ],
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: SizedBox(
                  height: weeklyCardHeight.clamp(220.0, 350.0),
                  child: ReportCard(
                    userRole: userRole,
                    title: 'Weekly Progress Report',
                    chart: WeeklyProgressChart(data: state.weeklyProgress),
                    clients: state.clients,
                    selectedClient: state.weeklyProgressClientId,
                    onClientChanged: (client) {
                      context.read<DashboardBloc>().add(
                        FilterWeeklyProgressByClientEvent(clientId: client),
                      );
                    },
                    periods: const [
                      'This Week',
                      'Previous Week',
                      'This Month',
                      'Previous Month',
                    ],
                    selectedPeriod: state.weeklyProgressPeriod,
                    onPeriodChanged: (period) {
                      if (period != null) {
                        context.read<DashboardBloc>().add(
                          FilterWeeklyProgressByPeriodEvent(period: period),
                        );
                      }
                    },
                    exchanges: state.exchanges,
                    selectedExchanges: state.weeklyProgressSelectedExchanges,
                    onExchangeToggle: (exchange) {
                      context.read<DashboardBloc>().add(
                        ToggleWeeklyProgressExchangeEvent(exchange: exchange),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTradeReportsCard(
    BuildContext context,
    DashboardLoaded state,
    String? userRole,
  ) {
    return ReportCard(
      userRole: userRole,
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
    );
  }

  Widget _buildSymbolWiseCard(
    BuildContext context,
    DashboardLoaded state,
    String? userRole,
  ) {
    return ReportCard(
      userRole: userRole,
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
            ChangeSymbolReportTopCountEvent(topCount: int.parse(topCount)),
          );
        }
      },
    );
  }
}

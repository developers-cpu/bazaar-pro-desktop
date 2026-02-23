import 'package:bazarpro/features/report/presentation/pages/bill_generate_page.dart';
import 'package:bazarpro/features/report/presentation/pages/symbol_wise_pl_report_page.dart';
import 'package:bazarpro/features/report/presentation/pages/profit_and_loss_report_page.dart';
import 'package:bazarpro/features/report/presentation/pages/settlement_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import 'trade_logs_page.dart';
import 'credit_history_page.dart';
import 'activity_report_page.dart';
import 'symbol_wise_position_report_page.dart';
import 'user_script_position_tracking_page.dart';
import 'user_wise_profit_and_loss_page.dart';
import 'exchange_wise_pl_report_page.dart';

class ReportPageWrapper extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  const ReportPageWrapper({
    Key? key,
    required this.pageTitle,
    required this.child,
    this.onExportPdf,
    this.onExportExcel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? userRole;
        if (state is AuthAuthenticated) {
          userRole = state.user.role;
        }
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBarSection(
            selectedTabIndex: userRole == 'Client' ? 3 : 4,
            userRole: userRole,
            currentPageTitle: pageTitle,
            onTabSelected: (_) {},
            onExportPdf: onExportPdf,
            onExportExcel: onExportExcel,
            showExportByDefault: true,
          ),
          body: child,
        );
      },
    );
  }
}

class TradeLogsPageWithAppBar extends StatelessWidget {
  const TradeLogsPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Trade Logs',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const TradeLogsPage(),
    );
  }
}

class SettlementPageWithAppBar extends StatelessWidget {
  const SettlementPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Settlement',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const SettlementReportPage(),
    );
  }
}

class CreditHistoryPageWithAppBar extends StatelessWidget {
  const CreditHistoryPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Credit History',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const CreditHistoryPage(),
    );
  }
}

class BillGeneratePageWithAppBar extends StatelessWidget {
  const BillGeneratePageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Bill Generate',
      onExportPdf: () {},
      onExportExcel: () {},
      child: BillGeneratePage(),
    );
  }
}

class ActivityReportPageWithAppBar extends StatelessWidget {
  const ActivityReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Activity Report',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const ActivityReportPage(),
    );
  }
}

class ProfitAndLossPageWithAppBar extends StatelessWidget {
  const ProfitAndLossPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Profit & Loss',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const ProfitAndLossReportPage(),
    );
  }
}

class UserWisePLPageWithAppBar extends StatelessWidget {
  const UserWisePLPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'User Wise Profit & Loss',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const UserWiseProfitAndLossPage(),
    );
  }
}

class UserScriptPositionTrackingPageWithAppBar extends StatelessWidget {
  const UserScriptPositionTrackingPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'User Script Position Tracking',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const UserScriptPositionTrackingPage(),
    );
  }
}

class SymbolWisePositionReportPageWithAppBar extends StatelessWidget {
  const SymbolWisePositionReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Symbol Wise Position Report',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const SymbolWisePositionReportPage(),
    );
  }
}

class SymbolWisePLPageWithAppBar extends StatelessWidget {
  const SymbolWisePLPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Symbol Wise PL',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const SymbolWisePLReportPage(),
    );
  }
}

class ExchangeWiseReportPageWithAppBar extends StatelessWidget {
  const ExchangeWiseReportPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Exchange Wise Report',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const ExchangeWisePLReportPage(),
    );
  }
}

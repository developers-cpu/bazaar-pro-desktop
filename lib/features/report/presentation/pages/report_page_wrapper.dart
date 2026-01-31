import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import 'trade_logs_page.dart';

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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarSection(
        selectedTabIndex: 4,
        currentPageTitle: pageTitle,
        onTabSelected: (_) {},
        onExportPdf: onExportPdf,
        onExportExcel: onExportExcel,
        showExportByDefault: true,
      ),
      body: child,
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

class TradeMarginPageWithAppBar extends StatelessWidget {
  const TradeMarginPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      pageTitle: 'Trade Margin',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Trade Margin - Coming Soon')),
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
      child: const Center(child: Text('Settlement - Coming Soon')),
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
      child: const Center(child: Text('Credit History - Coming Soon')),
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
      child: const Center(child: Text('Bill Generate - Coming Soon')),
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
      child: const Center(child: Text('Activity Report - Coming Soon')),
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
      child: const Center(child: Text('Profit & Loss - Coming Soon')),
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
      child: const Center(child: Text('User Wise Profit & Loss - Coming Soon')),
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
      child: const Center(
        child: Text('User Script Position Tracking - Coming Soon'),
      ),
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
      child: const Center(
        child: Text('Symbol Wise Position Report - Coming Soon'),
      ),
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
      child: const Center(child: Text('Symbol Wise PL - Coming Soon')),
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
      child: const Center(child: Text('Exchange Wise Report - Coming Soon')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../bloc/pending_orders/pending_orders_bloc.dart';
import '../bloc/pending_orders/pending_orders_event.dart';
import 'pending_orders_page.dart';

/// View Page Wrapper
class ViewPageWrapper extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;

  const ViewPageWrapper({
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
        selectedTabIndex: 2, // View tab is selected
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


class PendingOrdersPageWithAppBar extends StatelessWidget {
  const PendingOrdersPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PendingOrdersBloc(),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Pending Orders',
            onExportPdf: () {
              context.read<PendingOrdersBloc>().add(const ExportToPdfEvent());
            },
            onExportExcel: () {
              context.read<PendingOrdersBloc>().add(const ExportToExcelEvent());
            },
            child: const PendingOrdersPage(),
          );
        },
      ),
    );
  }
}

/// Trades Page with Wrapper
class TradesPageWithAppBar extends StatelessWidget {
  const TradesPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Trades',
      onExportPdf: () {
        // TODO: Implement PDF export for Trades
      },
      onExportExcel: () {
        // TODO: Implement Excel export for Trades
      },
      child: const Center(child: Text('Trades Page - Coming Soon')),
    );
  }
}

/// Deals Page with Wrapper
class DealsPageWithAppBar extends StatelessWidget {
  const DealsPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Deals',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Deals Page - Coming Soon')),
    );
  }
}

/// Net Position Page with Wrapper
class NetPositionPageWithAppBar extends StatelessWidget {
  const NetPositionPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Net Position',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Net Position Page - Coming Soon')),
    );
  }
}

/// Rejection Log Page with Wrapper
class RejectionLogPageWithAppBar extends StatelessWidget {
  const RejectionLogPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Rejection Log',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Rejection Log Page - Coming Soon')),
    );
  }
}

/// Login History Page with Wrapper
class LoginHistoryPageWithAppBar extends StatelessWidget {
  const LoginHistoryPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Login History',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Login History Page - Coming Soon')),
    );
  }
}

/// Intraday History Page with Wrapper
class IntradayHistoryPageWithAppBar extends StatelessWidget {
  const IntradayHistoryPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Intraday History',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Intraday History Page - Coming Soon')),
    );
  }
}

/// Script Master Page with Wrapper
class ScriptMasterPageWithAppBar extends StatelessWidget {
  const ScriptMasterPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Script Master',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Script Master Page - Coming Soon')),
    );
  }
}

/// Script Quantity Page with Wrapper
class ScriptQuantityPageWithAppBar extends StatelessWidget {
  const ScriptQuantityPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Script Quantity',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Script Quantity Page - Coming Soon')),
    );
  }
}

/// Bulk Trade Page with Wrapper
class BulkTradePageWithAppBar extends StatelessWidget {
  const BulkTradePageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Bulk Trade',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Bulk Trade Page - Coming Soon')),
    );
  }
}

/// Total Volume Page with Wrapper
class TotalVolumePageWithAppBar extends StatelessWidget {
  const TotalVolumePageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Total Volume',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Total Volume Page - Coming Soon')),
    );
  }
}

/// Deleted Trade Page with Wrapper
class DeletedTradePageWithAppBar extends StatelessWidget {
  const DeletedTradePageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Deleted Trade',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Deleted Trade Page - Coming Soon')),
    );
  }
}

/// Manual Trade Page with Wrapper
class ManualTradePageWithAppBar extends StatelessWidget {
  const ManualTradePageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewPageWrapper(
      pageTitle: 'Manual Trade',
      onExportPdf: () {},
      onExportExcel: () {},
      child: const Center(child: Text('Manual Trade Page - Coming Soon')),
    );
  }
}
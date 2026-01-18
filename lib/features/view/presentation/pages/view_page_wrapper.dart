import 'package:bazarpro/features/view/presentation/pages/rejection_log_page.dart';
import 'package:bazarpro/features/view/presentation/pages/script_master_page.dart';
import 'package:bazarpro/features/view/presentation/pages/script_quantity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../bloc/deals/deals_bloc.dart';
import '../bloc/deals/deals_event.dart';
import '../bloc/login_history/login_history_bloc.dart';
import '../bloc/login_history/login_history_event.dart';
import '../bloc/net_position/net_position_bloc.dart';
import '../bloc/net_position/net_position_event.dart';
import '../bloc/pending_orders/pending_orders_bloc.dart';
import '../bloc/pending_orders/pending_orders_event.dart';
import '../bloc/rejection_log/rejection_log_bloc.dart';
import '../bloc/rejection_log/rejection_log_event.dart';
import '../bloc/script_master/script_master_bloc.dart';
import '../bloc/script_master/script_master_event.dart';
import '../bloc/script_quantity/script_quantity_bloc.dart';
import '../bloc/script_quantity/script_quantity_event.dart';
import '../bloc/trade/trades_bloc.dart';
import '../bloc/trade/trades_event.dart';
import 'deals_page.dart';
import 'login_history_page.dart';
import 'net_position_page.dart';
import 'pending_orders_page.dart';
import 'trades_page.dart';
import '../../../../../injection_container.dart' as di;

/// View Page Wrapper
/// Wraps all View section pages with the common AppBar that includes export icons
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

/// Pending Orders Page with Wrapper
/// Complete page with AppBar and export functionality
class PendingOrdersPageWithAppBar extends StatelessWidget {
  const PendingOrdersPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PendingOrdersBloc>(),
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
    return BlocProvider(
      create: (context) => di.sl<TradesBloc>(),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Trades',
            onExportPdf: () {
              context.read<TradesBloc>().add(const ExportTradesToPdfEvent());
            },
            onExportExcel: () {
              context.read<TradesBloc>().add(const ExportTradesToExcelEvent());
            },
            child: const TradesPage(),
          );
        },
      ),
    );
  }
}

/// Deals Page with Wrapper
class DealsPageWithAppBar extends StatelessWidget {
  const DealsPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<DealsBloc>()..add(const LoadDealsEvent()),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Deals',
            onExportPdf: () {
              context.read<DealsBloc>().add(const ExportDealsToPdfEvent());
            },
            onExportExcel: () {
              context.read<DealsBloc>().add(const ExportDealsToExcelEvent());
            },
            child: const DealsPage(),
          );
        },
      ),
    );
  }
}

/// Net Position Page with Wrapper - UPDATED WITH FUNCTIONALITY
class NetPositionPageWithAppBar extends StatelessWidget {
  const NetPositionPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<NetPositionBloc>()..add(const LoadNetPositionsEvent()),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Net Position',
            onExportPdf: () {
              context.read<NetPositionBloc>().add(const ExportNetPositionsToPdfEvent());
            },
            onExportExcel: () {
              context.read<NetPositionBloc>().add(const ExportNetPositionsToExcelEvent());
            },
            child: const NetPositionPage(),
          );
        },
      ),
    );
  }
}

/// Rejection Log Page with Wrapper
class RejectionLogPageWithAppBar extends StatelessWidget {
  const RejectionLogPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RejectionLogBloc>()
        ..add(const LoadRejectionLogsEvent()),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Rejection Log',
            onExportPdf: () {
              context
                  .read<RejectionLogBloc>()
                  .add(const ExportRejectionLogsToPdfEvent());
            },
            onExportExcel: () {
              context
                  .read<RejectionLogBloc>()
                  .add(const ExportRejectionLogsToExcelEvent());
            },
            child: const RejectionLogPage(),
          );
        },
      ),
    );
  }
}

/// Login History Page with Wrapper
class LoginHistoryPageWithAppBar extends StatelessWidget {
  const LoginHistoryPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LoginHistoryBloc>()
        ..add(const LoadClientsEvent()),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Login History',
            onExportPdf: () {
              context
                  .read<LoginHistoryBloc>()
                  .add(const ExportLoginHistoryToPdfEvent());
            },
            onExportExcel: () {
              context
                  .read<LoginHistoryBloc>()
                  .add(const ExportLoginHistoryToExcelEvent());
            },
            child: const LoginHistoryPage(),
          );
        },
      ),
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
/// Script Master Page with Wrapper (UPDATED)
class ScriptMasterPageWithAppBar extends StatelessWidget {
  const ScriptMasterPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ScriptMasterBloc>()
        ..add(const LoadScriptMastersEvent()),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Script Master',

            onExportPdf: () {
              context
                  .read<ScriptMasterBloc>()
                  .add(const ExportScriptMastersToPdfEvent());
            },

            onExportExcel: () {
              context
                  .read<ScriptMasterBloc>()
                  .add(const ExportScriptMastersToExcelEvent());
            },

            child: const ScriptMasterPage(),
          );
        },
      ),
    );
  }
}


/// Script Quantity Page with Wrapper
class ScriptQuantityPageWithAppBar extends StatelessWidget {
  const ScriptQuantityPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ScriptQuantityBloc>()
        ..add(const LoadFiltersEvent()),
      child: Builder(
        builder: (context) {
          return ViewPageWrapper(
            pageTitle: 'Script Quantity',
            // No export buttons needed for this page
            child: const ScriptQuantityPage(),
          );
        },
      ),
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
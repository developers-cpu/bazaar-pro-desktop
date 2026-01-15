import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/market_watch/presentation/pages/market_watch_page.dart';
import '../../features/view/presentation/pages/view_page_wrapper.dart';

/// App Routes Configuration
class AppRoutes {
  // Route names
  static const String login = '/';
  static const String marketWatch = '/market-watch';
  static const String dashboard = '/dashboard';

  // View routes
  static const String pendingOrders = '/pending_order-orders';
  static const String trades = '/trades';
  static const String deals = '/deals';
  static const String netPosition = '/net-position';
  static const String rejectionLog = '/rejection-log';
  static const String loginHistory = '/login-history';
  static const String intradayHistory = '/intraday-history';
  static const String scriptMaster = '/script-master';
  static const String scriptQuantity = '/script-quantity';
  static const String bulkTrade = '/bulk-trade';
  static const String totalVolume = '/total-volume';
  static const String deletedTrade = '/deleted-trade';
  static const String manualTrade = '/manual-trade';

  // User routes
  static const String createUser = '/create-user';
  static const String inactiveUser = '/inactive-user';
  static const String searchUser = '/search-user';

  // Report routes
  static const String dailyReport = '/daily-report';
  static const String weeklyReport = '/weekly-report';
  static const String monthlyReport = '/monthly-report';
  static const String customReport = '/custom-report';

  // Tools route
  static const String tools = '/tools';

  /// Get all routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Main routes
      login: (context) => const LoginPage(),
      marketWatch: (context) => const MarketWatchPage(),
      dashboard: (context) => const DashboardPageWithAppBar(), // Changed to use wrapper

      // View dropdown routes - using pages with AppBar wrapper
      pendingOrders: (context) => const PendingOrdersPageWithAppBar(),
      trades: (context) => const TradesPageWithAppBar(),
      deals: (context) => const DealsPageWithAppBar(),
      netPosition: (context) => const NetPositionPageWithAppBar(),
      rejectionLog: (context) => const RejectionLogPageWithAppBar(),
      loginHistory: (context) => const LoginHistoryPageWithAppBar(),
      intradayHistory: (context) => const IntradayHistoryPageWithAppBar(),
      scriptMaster: (context) => const ScriptMasterPageWithAppBar(),
      scriptQuantity: (context) => const ScriptQuantityPageWithAppBar(),
      bulkTrade: (context) => const BulkTradePageWithAppBar(),
      totalVolume: (context) => const TotalVolumePageWithAppBar(),
      deletedTrade: (context) => const DeletedTradePageWithAppBar(),
      manualTrade: (context) => const ManualTradePageWithAppBar(),

      // User dropdown routes
      createUser: (context) => const _PlaceholderPage(title: 'Create User'),
      inactiveUser: (context) => const _PlaceholderPage(title: 'In-Active User'),
      searchUser: (context) => const _PlaceholderPage(title: 'Search User'),

      // Report dropdown routes
      dailyReport: (context) => const _PlaceholderPage(title: 'Daily Report'),
      weeklyReport: (context) => const _PlaceholderPage(title: 'Weekly Report'),
      monthlyReport: (context) => const _PlaceholderPage(title: 'Monthly Report'),
      customReport: (context) => const _PlaceholderPage(title: 'Custom Report'),

      // Tools route
      tools: (context) => const _PlaceholderPage(title: 'Tools'),
    };
  }
}

/// Placeholder page for routes that are not yet implemented
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('$title - Coming Soon'),
      ),
    );
  }
}
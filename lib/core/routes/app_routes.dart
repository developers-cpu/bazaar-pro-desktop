import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/market_watch/presentation/pages/market_watch_page.dart';
import '../../features/view/presentation/pages/view_page_wrapper.dart';
import '../../features/users/presentation/pages/user_page_wrapper.dart';


class AppRoutes {
  
  static const String login = '/';
  static const String marketWatch = '/market-watch';
  static const String dashboard = '/dashboard';

  
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

  
  static const String createUser = '/create-user';
  static const String inactiveUser = '/inactive-user';
  static const String searchUser = '/search-user';
  static const String userList = '/user-list';

  
  static const String dailyReport = '/daily-report';
  static const String weeklyReport = '/weekly-report';
  static const String monthlyReport = '/monthly-report';
  static const String customReport = '/custom-report';

  
  static const String tools = '/tools';

  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      
      login: (context) => const LoginPage(),
      marketWatch: (context) => const MarketWatchPage(),
      dashboard: (context) => const DashboardPageWithAppBar(),

      
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

      
      createUser: (context) => const CreateUserPageWithAppBar(),
      inactiveUser: (context) => const InactiveUserPageWithAppBar(),
      userList: (context) => const UserListPageWithAppBar(),

      
      dailyReport: (context) => const _PlaceholderPage(title: 'Daily Report'),
      weeklyReport: (context) => const _PlaceholderPage(title: 'Weekly Report'),
      monthlyReport: (context) =>
          const _PlaceholderPage(title: 'Monthly Report'),
      customReport: (context) => const _PlaceholderPage(title: 'Custom Report'),

      
      tools: (context) => const _PlaceholderPage(title: 'Tools'),
    };
  }
}


class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title - Coming Soon')),
    );
  }
}

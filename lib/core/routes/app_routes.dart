import 'package:flutter/material.dart';

import '../../features/market_watch/presentation/pages/dummy/dummy_page.dart';


/// App Routes Configuration
class AppRoutes {
  // Route names
  static const String home = '/';
  static const String pendingOrders = '/pending-orders';
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
  static const String dailyReport = '/daily-report';
  static const String weeklyReport = '/weekly-report';
  static const String monthlyReport = '/monthly-report';
  static const String customReport = '/custom-report';

  /// Get all routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // View dropdown routes
      pendingOrders: (context) => const PendingOrdersPage(),
      trades: (context) => const TradesPage(),
      deals: (context) => const DealsPage(),
      netPosition: (context) => const NetPositionPage(),
      rejectionLog: (context) => const RejectionLogPage(),
      loginHistory: (context) => const LoginHistoryPage(),
      intradayHistory: (context) => const IntradayHistoryPage(),
      scriptMaster: (context) => const ScriptMasterPage(),
      scriptQuantity: (context) => const ScriptQuantityPage(),
      bulkTrade: (context) => const BulkTradePage(),
      totalVolume: (context) => const TotalVolumePage(),
      deletedTrade: (context) => const DeletedTradePage(),
      manualTrade: (context) => const ManualTradePage(),

      // User dropdown routes
      createUser: (context) => const CreateUserPage(),
      inactiveUser: (context) => const InactiveUserPage(),
      searchUser: (context) => const SearchUserPage(),

      // Report dropdown routes
      dailyReport: (context) => const DailyReportPage(),
      weeklyReport: (context) => const WeeklyReportPage(),
      monthlyReport: (context) => const MonthlyReportPage(),
      customReport: (context) => const CustomReportPage(),
    };
  }
}
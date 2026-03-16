import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/market_watch/presentation/pages/market_watch_page.dart';
import '../../features/view/presentation/pages/view_page_wrapper.dart';
import '../../features/users/presentation/pages/user_page_wrapper.dart';
import '../../features/report/presentation/pages/report_page_wrapper.dart';
import '../../features/tools/presentation/pages/tools_page_wrapper.dart';
import '../../features/operations/presentation/pages/operations_page_wrapper.dart';
import '../../features/operations/presentation/pages/exchange_settings/exchange_settings_page.dart';
import '../../features/operations/presentation/pages/trade_settings/trade_settings_page.dart';
import '../../features/operations/presentation/pages/group/group_page.dart';

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
  static const String brokerList = '/broker-list';
  static const String brokerage = '/brokerage';
  static const String createUser = '/create-user';
  static const String inactiveUser = '/inactive-user';
  static const String searchUser = '/search-user';
  static const String userList = '/user-list';
  static const String tradeLogs = '/trade-logs';
  static const String tradeMargin = '/trade-margin';
  static const String settlement = '/settlement';
  static const String settlementWithSharing = '/settlement-with-sharing';
  static const String creditHistory = '/credit-history';
  static const String billGenerate = '/bill-generate';
  static const String activityReport = '/activity-report';
  static const String profitLoss = '/profit-loss';
  static const String userWisePL = '/user-wise-pl';
  static const String userScriptPosition = '/user-script-position';
  static const String symbolWisePosition = '/symbol-wise-position';
  static const String symbolWisePL = '/symbol-wise-pl';
  static const String exchangeWiseReport = '/exchange-wise-report';
  static const String rejectedTrade = '/rejected-trade';
  static const String exchangeSettings = '/exchange-settings';
  static const String group = '/group';
  static const String tradeSettings = '/trade-settings';
  static const String dateSettings = '/date-settings';
  static const String scriptSettings = '/script-settings';
  static const String surveillance = '/surveillance';
  static const String settlementProgress = '/settlement-progress';
  static const String server = '/server';
  static const String billComparison = '/bill-comparison';
  static const String settlementMasterSharing = '/settlement-master-sharing';
  static const String inactivityManagement = '/inactivity-management';
  static const String operationsMessage = '/operations-message';
  static const String tools = '/tools';
  static const String toolsAbout = '/tools/about';
  static const String toolsChangePassword = '/tools/change-password';
  static const String toolsMarketTiming = '/tools/market-timing';
  static const String toolsMessage = '/tools/message';
  static const String toolsAnnouncement = '/tools/announcement';
  static const String toolsRulesRegulations = '/tools/rules-regulations';
  static const String toolsShortcuts = '/tools/shortcuts';
  static const String toolsTotalVolume = '/tools/total-volume';
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
      brokerList: (context) => const BrokerListPageWithAppBar(),
      brokerage: (context) => const BrokeragePageWithAppBar(),
      createUser: (context) => const CreateUserPageWithAppBar(),
      inactiveUser: (context) => const InactiveUserPageWithAppBar(),
      tradeLogs: (context) => const TradeLogsPageWithAppBar(),
      tradeMargin: (context) => const TradeMarginPageWithAppBar(),
      settlement: (context) => const SettlementPageWithAppBar(),
      settlementWithSharing: (context) =>
          const SettlementSharingReportPageWithAppBar(),
      creditHistory: (context) => const CreditHistoryPageWithAppBar(),
      billGenerate: (context) => const BillGeneratePageWithAppBar(),
      activityReport: (context) => const ActivityReportPageWithAppBar(),
      profitLoss: (context) => const ProfitAndLossPageWithAppBar(),
      userWisePL: (context) => const UserWisePLPageWithAppBar(),
      userScriptPosition: (context) =>
          const UserScriptPositionTrackingPageWithAppBar(),
      symbolWisePosition: (context) =>
          const SymbolWisePositionReportPageWithAppBar(),
      symbolWisePL: (context) => const SymbolWisePLPageWithAppBar(),
      exchangeWiseReport: (context) => const ExchangeWiseReportPageWithAppBar(),
      rejectedTrade: (context) => const RejectedTradePageWithAppBar(),
      exchangeSettings: (context) => const ExchangeSettingsPageWithAppBar(),
      group: (context) => const GroupPageWithAppBar(),
      tradeSettings: (context) => const TradeSettingsPageWithAppBar(),
      dateSettings: (context) => const DateSettingsPageWithAppBar(),
      scriptSettings: (context) => const ScriptSettingsPageWithAppBar(),
      surveillance: (context) => const SurveillancePageWithAppBar(),
      settlementProgress: (context) => const SettlementProgressPageWithAppBar(),
      server: (context) => const ServerPageWithAppBar(),
      billComparison: (context) => const BillComparisonPageWithAppBar(),
      settlementMasterSharing: (context) =>
          const SettlementMasterSharingPageWithAppBar(),
      operationsMessage: (context) => const OperationsMessagePageWithAppBar(),
      tools: (context) => const AboutPageWithAppBar(),
      toolsAbout: (context) => const AboutPageWithAppBar(),
      toolsChangePassword: (context) => const ChangePasswordPageWithAppBar(),
      toolsMarketTiming: (context) => const MarketTimingPageWithAppBar(),
      toolsMessage: (context) => const MessagePageWithAppBar(),
      toolsAnnouncement: (context) => const AnnouncementPageWithAppBar(),
      toolsRulesRegulations: (context) =>
          const RulesRegulationsPageWithAppBar(),
      toolsShortcuts: (context) => const ShortcutsPageWithAppBar(),
      toolsTotalVolume: (context) => const ToolsTotalVolumePageWithAppBar(),
    };
  }
}

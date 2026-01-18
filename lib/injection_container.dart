import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/market_watch/data/datasources/market_watch_local_datasource.dart';
import 'features/market_watch/data/repositories/market_watch_repository_impl.dart';
import 'features/market_watch/domain/repositories/market_watch_repository.dart';
import 'features/market_watch/domain/usecases/add_market_item.dart';
import 'features/market_watch/domain/usecases/delete_market_item.dart';
import 'features/market_watch/domain/usecases/get_market_items.dart';
import 'features/market_watch/presentation/bloc/arrangesymbol/arrange_symbol_bloc.dart';
import 'features/market_watch/presentation/bloc/market_depth/market_depth_bloc.dart';
import 'features/market_watch/presentation/bloc/marketwatch/market_watch_bloc.dart';
import 'features/market_watch/presentation/bloc/order/order_dialog_bloc.dart';
import 'features/market_watch/presentation/bloc/symbolfont/symbol_font_bloc.dart';
import 'features/market_watch/presentation/bloc/theme/theme_bloc.dart';
import 'features/market_watch/presentation/bloc/watchlist/watch_list_bloc.dart';
// View Feature imports
import 'features/view/data/datasources/deals_remote_datasource.dart';
import 'features/view/data/datasources/intraday_history_remote_datasource.dart';
import 'features/view/data/datasources/login_history_remote_datasource.dart';
import 'features/view/data/datasources/net_position_remote_datasource.dart';
import 'features/view/data/datasources/pending_orders_remote_datasource.dart';
import 'features/view/data/datasources/rejection_log_remote_datasource.dart';
import 'features/view/data/datasources/script_master_remote_datasource.dart';
import 'features/view/data/datasources/script_quantity_remote_datasource.dart';
import 'features/view/data/datasources/trades_remote_datasource.dart';
import 'features/view/data/repositories/deals_repository_impl.dart';
import 'features/view/data/repositories/intraday_history_repository_impl.dart';
import 'features/view/data/repositories/login_history_repository_impl.dart';
import 'features/view/data/repositories/net_position_repository_impl.dart';
import 'features/view/data/repositories/pending_orders_repository_impl.dart';
import 'features/view/data/repositories/rejection_log_repository_impl.dart';
import 'features/view/data/repositories/script_master_repository_impl.dart';
import 'features/view/data/repositories/script_quantity_repository_impl.dart';
import 'features/view/data/repositories/trades_repository_impl.dart';
import 'features/view/domain/repositories/deals_repository.dart';
import 'features/view/domain/repositories/intraday_history_repository.dart';
import 'features/view/domain/repositories/login_history_repository.dart';
import 'features/view/domain/repositories/net_position_repository.dart';
import 'features/view/domain/repositories/pending_orders_repository.dart';
import 'features/view/domain/repositories/rejection_log_repository.dart';
import 'features/view/domain/repositories/script_master_repository.dart';
import 'features/view/domain/repositories/script_quantity_repository.dart';
import 'features/view/domain/repositories/trades_repository.dart';
import 'features/view/domain/usecases/ rejection_log/rejection_log_usecases.dart';
import 'features/view/domain/usecases/deals/deals_usecases.dart';
import 'features/view/domain/usecases/intraday_history/intraday_history_usecases.dart';
import 'features/view/domain/usecases/login_history/login_history_usecases.dart';
import 'features/view/domain/usecases/netposition/net_position_usecases.dart';
import 'features/view/domain/usecases/pending_order/export_orders.dart';
import 'features/view/domain/usecases/pending_order/get_filter_data.dart';
import 'features/view/domain/usecases/pending_order/get_pending_orders.dart';
import 'features/view/domain/usecases/script_master/script_master_usecases.dart';
import 'features/view/domain/usecases/script_quantity/script_quantity_usecases.dart';
import 'features/view/domain/usecases/trade/trades_usecases.dart';
import 'features/view/presentation/bloc/deals/deals_bloc.dart';
import 'features/view/presentation/bloc/intraday_history/intraday_history_bloc.dart';
import 'features/view/presentation/bloc/login_history/login_history_bloc.dart';
import 'features/view/presentation/bloc/net_position/net_position_bloc.dart';
import 'features/view/presentation/bloc/pending_orders/pending_orders_bloc.dart';
import 'features/view/presentation/bloc/rejection_log/rejection_log_bloc.dart';
import 'features/view/presentation/bloc/script_master/script_master_bloc.dart';
import 'features/view/presentation/bloc/script_quantity/script_quantity_bloc.dart';
import 'features/view/presentation/bloc/trade/trades_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================================
  // CORE - Register first to avoid dependency issues
  // ============================================================

  // API Client
  sl.registerLazySingleton(() => ApiClient());

  // ============================================================
  // AUTH FEATURE
  // ============================================================

  // Auth BLoC
  sl.registerFactory(() => AuthBloc(loginUser: sl()));

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginUser(repository: sl()));

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // MARKET WATCH FEATURE
  // ============================================================

  // Market Watch BLoC
  sl.registerFactory(() => MarketWatchBloc(
    getMarketItems: sl(),
    addMarketItem: sl(),
    deleteMarketItem: sl(),
  ));

  // Theme BLoC - Singleton to persist theme state across screens
  sl.registerLazySingleton(() => ThemeBloc());

  // Watchlist BLoC
  sl.registerFactory(() => WatchlistBloc());

  // Arrange Symbol BLoC - Singleton to persist column arrangement
  sl.registerLazySingleton(() => ArrangeSymbolBloc());

  // Symbol Font BLoC - Singleton to persist font settings
  sl.registerLazySingleton(() => SymbolFontBloc());

  // Order Dialog BLoC - Singleton for Buy/Sell dialogs
  sl.registerLazySingleton(() => OrderDialogBloc());

  // Market Depth BLoC - Singleton for Market Depth dialog (F5)
  sl.registerLazySingleton(() => MarketDepthBloc());

  // Market Watch Use Cases
  sl.registerLazySingleton(() => GetMarketItems(sl()));
  sl.registerLazySingleton(() => AddMarketItem(sl()));
  sl.registerLazySingleton(() => DeleteMarketItem(sl()));

  // Market Watch Repository
  sl.registerLazySingleton<MarketWatchRepository>(
        () => MarketWatchRepositoryImpl(localDataSource: sl()),
  );

  // Market Watch Data Sources
  sl.registerLazySingleton<MarketWatchLocalDataSource>(
        () => MarketWatchLocalDataSourceImpl(),
  );

  // ============================================================
  // DASHBOARD FEATURE
  // ============================================================

  // Dashboard BLoC
  sl.registerFactory(() => DashboardBloc(repository: sl()));

  // Dashboard Use Cases
  sl.registerLazySingleton(() => GetDashboardDataUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTradeReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSymbolReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(repository: sl()));

  // Dashboard Repository
  sl.registerLazySingleton<DashboardRepository>(
        () => DashboardRepositoryImpl(dataSource: sl()),
  );

  // Dashboard Data Sources
  sl.registerLazySingleton<DashboardDataSource>(
        () => DashboardDataSource(),
  );

  // ============================================================
  // VIEW FEATURE - PENDING ORDERS
  // ============================================================

  // Pending Orders BLoC
  sl.registerFactory(() => PendingOrdersBloc(
    getPendingOrders: sl(),
    getPendingOrdersWithFilters: sl(),
    getClients: sl(),
    getExchanges: sl(),
    getSymbols: sl(),
    getOrderTypes: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
  ));

  // Pending Orders Use Cases
  sl.registerLazySingleton(() => GetPendingOrders(sl()));
  sl.registerLazySingleton(() => GetPendingOrdersWithFilters(sl()));
  sl.registerLazySingleton(() => GetClients(sl()));
  sl.registerLazySingleton(() => GetExchanges(sl()));
  sl.registerLazySingleton(() => GetSymbols(sl()));
  sl.registerLazySingleton(() => GetOrderTypes(sl()));
  sl.registerLazySingleton(() => ExportToPdf(sl()));
  sl.registerLazySingleton(() => ExportToExcel(sl()));

  // Pending Orders Repository
  sl.registerLazySingleton<PendingOrdersRepository>(
        () => PendingOrdersRepositoryImpl(remoteDataSource: sl()),
  );

  // Pending Orders Data Sources
  sl.registerLazySingleton<PendingOrdersRemoteDataSource>(
        () => PendingOrdersRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // VIEW FEATURE - TRADES
  // ============================================================

  // Trades BLoC
  sl.registerFactory(() => TradesBloc(
    getTrades: sl(),
    getTradesWithFilters: sl(),
    getClients: sl(),
    getExchanges: sl(),
    getSymbols: sl(),
    getOrderTypes: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
  ));

  // Trades Use Cases
  sl.registerLazySingleton(() => GetTrades(sl()));
  sl.registerLazySingleton(() => GetTradesWithFilters(sl()));
  sl.registerLazySingleton(() => GetTradesClients(sl()));
  sl.registerLazySingleton(() => GetTradesExchanges(sl()));
  sl.registerLazySingleton(() => GetTradesSymbols(sl()));
  sl.registerLazySingleton(() => GetTradesOrderTypes(sl()));
  sl.registerLazySingleton(() => ExportTradesToPdf(sl()));
  sl.registerLazySingleton(() => ExportTradesToExcel(sl()));

  // Trades Repository
  sl.registerLazySingleton<TradesRepository>(
        () => TradesRepositoryImpl(remoteDataSource: sl()),
  );

  // Trades Data Sources
  sl.registerLazySingleton<TradesRemoteDataSource>(
        () => TradesRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // VIEW FEATURE - DEALS
  // ============================================================

  // Deals BLoC
  sl.registerFactory(() => DealsBloc(
    getDeals: sl(),
    getDealsWithFilters: sl(),
    getClients: sl(),
    getExchanges: sl(),
    getSymbols: sl(),
    getOrderTypes: sl(),
    getStatuses: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
  ));

  // Deals Use Cases
  sl.registerLazySingleton(() => GetDeals(sl()));
  sl.registerLazySingleton(() => GetDealsWithFilters(sl()));
  sl.registerLazySingleton(() => GetDealsClients(sl()));
  sl.registerLazySingleton(() => GetDealsExchanges(sl()));
  sl.registerLazySingleton(() => GetDealsSymbols(sl()));
  sl.registerLazySingleton(() => GetDealsOrderTypes(sl()));
  sl.registerLazySingleton(() => GetDealsStatuses(sl()));
  sl.registerLazySingleton(() => ExportDealsToPdf(sl()));
  sl.registerLazySingleton(() => ExportDealsToExcel(sl()));

  // Deals Repository
  sl.registerLazySingleton<DealsRepository>(
        () => DealsRepositoryImpl(remoteDataSource: sl()),
  );

  // Deals Data Sources
  sl.registerLazySingleton<DealsRemoteDataSource>(
        () => DealsRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // VIEW FEATURE - NET POSITION
  // ============================================================

  // Net Position BLoC
  sl.registerFactory(() => NetPositionBloc(
    getNetPositions: sl(),
    getNetPositionsWithFilters: sl(),
    getClients: sl(),
    getExchanges: sl(),
    getSymbols: sl(),
    getUserTypes: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
    getPositionDetails: sl(),
  ));

  // Net Position Use Cases
  sl.registerLazySingleton(() => GetNetPositions(sl()));
  sl.registerLazySingleton(() => GetNetPositionsWithFilters(sl()));
  sl.registerLazySingleton(() => GetNetPositionClients(sl()));
  sl.registerLazySingleton(() => GetNetPositionExchanges(sl()));
  sl.registerLazySingleton(() => GetNetPositionSymbols(sl()));
  sl.registerLazySingleton(() => GetNetPositionUserTypes(sl()));
  sl.registerLazySingleton(() => ExportNetPositionsToPdf(sl()));
  sl.registerLazySingleton(() => ExportNetPositionsToExcel(sl()));
  sl.registerLazySingleton(() => GetPositionDetails(sl()));

  // Net Position Repository
  sl.registerLazySingleton<NetPositionRepository>(
        () => NetPositionRepositoryImpl(remoteDataSource: sl()),
  );

  // Net Position Data Sources
  sl.registerLazySingleton<NetPositionRemoteDataSource>(
        () => NetPositionRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // VIEW FEATURE - REJECTION LOG
  // ============================================================

  // Rejection Log BLoC
  sl.registerFactory(() => RejectionLogBloc(
    getRejectionLogs: sl(),
    getRejectionLogsWithFilters: sl(),
    getClients: sl(),
    getExchanges: sl(),
    getSymbols: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
  ));

  // Rejection Log Use Cases
  sl.registerLazySingleton(() => GetRejectionLogs(sl()));
  sl.registerLazySingleton(() => GetRejectionLogsWithFilters(sl()));
  sl.registerLazySingleton(() => GetRejectionLogClients(sl()));
  sl.registerLazySingleton(() => GetRejectionLogExchanges(sl()));
  sl.registerLazySingleton(() => GetRejectionLogSymbols(sl()));
  sl.registerLazySingleton(() => ExportRejectionLogsToPdf(sl()));
  sl.registerLazySingleton(() => ExportRejectionLogsToExcel(sl()));

  // Rejection Log Repository
  sl.registerLazySingleton<RejectionLogRepository>(
        () => RejectionLogRepositoryImpl(remoteDataSource: sl()),
  );

  // Rejection Log Data Sources
  sl.registerLazySingleton<RejectionLogRemoteDataSource>(
        () => RejectionLogRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // VIEW FEATURE - LOGIN HISTORY
  // ============================================================

  // Login History BLoC
  sl.registerFactory(() => LoginHistoryBloc(
    getLoginHistory: sl(),
    getClients: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
  ));

  // Login History Use Cases
  sl.registerLazySingleton(() => GetLoginHistory(sl()));
  sl.registerLazySingleton(() => GetLoginHistoryClients(sl()));
  sl.registerLazySingleton(() => ExportLoginHistoryToPdf(sl()));
  sl.registerLazySingleton(() => ExportLoginHistoryToExcel(sl()));

  // Login History Repository
  sl.registerLazySingleton<LoginHistoryRepository>(
        () => LoginHistoryRepositoryImpl(remoteDataSource: sl()),
  );

  // Login History Data Sources
  sl.registerLazySingleton<LoginHistoryRemoteDataSource>(
        () => LoginHistoryRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // VIEW FEATURE - SCRIPT MASTER
  // ============================================================

  // Script Master BLoC
  sl.registerFactory(() => ScriptMasterBloc(
    getScriptMasters: sl(),
    getScriptMastersWithFilters: sl(),
    getExchanges: sl(),
    getSymbols: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
  ));

  // Script Master Use Cases
  sl.registerLazySingleton(() => GetScriptMasters(sl()));
  sl.registerLazySingleton(() => GetScriptMastersWithFilters(sl()));
  sl.registerLazySingleton(() => GetScriptMasterExchanges(sl()));
  sl.registerLazySingleton(() => GetScriptMasterSymbols(sl()));
  sl.registerLazySingleton(() => ExportScriptMastersToPdf(sl()));
  sl.registerLazySingleton(() => ExportScriptMastersToExcel(sl()));

  // Script Master Repository
  sl.registerLazySingleton<ScriptMasterRepository>(
        () => ScriptMasterRepositoryImpl(remoteDataSource: sl()),
  );

  // Script Master Data Sources
  sl.registerLazySingleton<ScriptMasterRemoteDataSource>(
        () => ScriptMasterRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // ============================================================
  // VIEW FEATURE - SCRIPT QUANTITY
  // ============================================================

  // Script Quantity BLoC
  sl.registerFactory(
        () => ScriptQuantityBloc(
      getExchanges: sl(),
      getGroups: sl(),
      getScriptQuantities: sl(),
    ),
  );

  // Script Quantity Use Cases
  sl.registerLazySingleton(() => GetScriptQuantityExchanges(sl()));
  sl.registerLazySingleton(() => GetScriptQuantityGroups(sl()));
  sl.registerLazySingleton(() => GetScriptQuantities(sl()));

  // Script Quantity Repository
  sl.registerLazySingleton<ScriptQuantityRepository>(
        () => ScriptQuantityRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Script Quantity Data Sources
  sl.registerLazySingleton<ScriptQuantityRemoteDataSource>(
        () => ScriptQuantityRemoteDataSourceImpl(
      dio: sl<ApiClient>().dio,
    ),
  );



  // ============================================================
  // VIEW FEATURE - INTRADAY HISTORY
  // ============================================================

  // Intraday History BLoC
  sl.registerFactory(() => IntradayHistoryBloc(
    getIntradayHistory: sl(),
    getIntradayHistoryInSeconds: sl(),
    getExchanges: sl(),
    getSymbols: sl(),
    getTimings: sl(),
    exportToPdf: sl(),
    exportToExcel: sl(),
  ));

  // Intraday History Use Cases
  sl.registerLazySingleton(() => GetIntradayHistory(sl()));
  sl.registerLazySingleton(() => GetIntradayHistoryInSeconds(sl()));
  sl.registerLazySingleton(() => GetIntradayExchanges(sl()));
  sl.registerLazySingleton(() => GetIntradaySymbols(sl()));
  sl.registerLazySingleton(() => GetIntradayTimings(sl()));
  sl.registerLazySingleton(() => GetAvailableTimeSlots(sl()));
  sl.registerLazySingleton(() => ExportIntradayToPdf(sl()));
  sl.registerLazySingleton(() => ExportIntradayToExcel(sl()));

  // Intraday History Repository
  sl.registerLazySingleton<IntradayHistoryRepository>(
        () => IntradayHistoryRepositoryImpl(remoteDataSource: sl()),
  );

  // Intraday History Data Sources
  sl.registerLazySingleton<IntradayHistoryRemoteDataSource>(
        () => IntradayHistoryRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

}
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
import 'features/view/data/datasources/deals/deals_remote_datasource.dart';
import 'features/view/data/datasources/intraday_history/intraday_history_remote_datasource.dart';
import 'features/view/data/datasources/login_history/login_history_remote_datasource.dart';
import 'features/view/data/datasources/net_position/net_position_remote_datasource.dart';
import 'features/view/data/datasources/pending_order/pending_orders_remote_datasource.dart';
import 'features/view/data/datasources/rejection_log/rejection_log_remote_datasource.dart';
import 'features/view/data/datasources/script_master/script_master_remote_datasource.dart';
import 'features/view/data/datasources/script_quantity/script_quantity_remote_datasource.dart';
import 'features/view/data/datasources/trades/trades_remote_datasource.dart';
import 'features/view/data/repositories/deals/deals_repository_impl.dart';
import 'features/view/data/repositories/intraday_history/intraday_history_repository_impl.dart';
import 'features/view/data/repositories/login_history/login_history_repository_impl.dart';
import 'features/view/data/repositories/net_postion/net_position_repository_impl.dart';
import 'features/view/data/repositories/pending_orders/pending_orders_repository_impl.dart';
import 'features/view/data/repositories/rejection_log/rejection_log_repository_impl.dart';
import 'features/view/data/repositories/script_master/script_master_repository_impl.dart';
import 'features/view/data/repositories/script_quantity/script_quantity_repository_impl.dart';
import 'features/view/data/repositories/trades/trades_repository_impl.dart';
import 'features/view/domain/repositories/deals/deals_repository.dart';
import 'features/view/domain/repositories/intraday_history/intraday_history_repository.dart';
import 'features/view/domain/repositories/login_history/login_history_repository.dart';
import 'features/view/domain/repositories/net_postion/net_position_repository.dart';
import 'features/view/domain/repositories/pending_orders/pending_orders_repository.dart';
import 'features/view/domain/repositories/rejection_log/rejection_log_repository.dart';
import 'features/view/domain/repositories/script_master/script_master_repository.dart';
import 'features/view/domain/repositories/script_quantity/script_quantity_repository.dart';
import 'features/view/domain/repositories/trades/trades_repository.dart';
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
import 'features/users/data/datasources/user_remote_datasource.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/domain/usecases/user_usecases.dart';
import 'features/users/presentation/bloc/user_list/user_list_bloc.dart';
import 'features/users/presentation/bloc/inactive_user_list/inactive_user_list_bloc.dart';
import 'features/users/presentation/bloc/search_user/search_user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
  
  

  
  sl.registerLazySingleton(() => ApiClient());

  
  
  

  
  sl.registerFactory(() => AuthBloc(loginUser: sl()));

  
  sl.registerLazySingleton(() => LoginUser(repository: sl()));

  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => MarketWatchBloc(
      getMarketItems: sl(),
      addMarketItem: sl(),
      deleteMarketItem: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => ThemeBloc());

  
  sl.registerFactory(() => WatchlistBloc());

  
  sl.registerLazySingleton(() => ArrangeSymbolBloc());

  
  sl.registerLazySingleton(() => SymbolFontBloc());

  
  sl.registerLazySingleton(() => OrderDialogBloc());

  
  sl.registerLazySingleton(() => MarketDepthBloc());

  
  sl.registerLazySingleton(() => GetMarketItems(sl()));
  sl.registerLazySingleton(() => AddMarketItem(sl()));
  sl.registerLazySingleton(() => DeleteMarketItem(sl()));

  
  sl.registerLazySingleton<MarketWatchRepository>(
    () => MarketWatchRepositoryImpl(localDataSource: sl()),
  );

  
  sl.registerLazySingleton<MarketWatchLocalDataSource>(
    () => MarketWatchLocalDataSourceImpl(),
  );

  
  
  

  
  sl.registerFactory(() => DashboardBloc(repository: sl()));

  
  sl.registerLazySingleton(() => GetDashboardDataUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTradeReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSymbolReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(repository: sl()));

  
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(dataSource: sl()),
  );

  
  sl.registerLazySingleton<DashboardDataSource>(() => DashboardDataSource());

  
  
  

  
  sl.registerFactory(
    () => PendingOrdersBloc(
      getPendingOrders: sl(),
      getPendingOrdersWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getOrderTypes: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetPendingOrders(sl()));
  sl.registerLazySingleton(() => GetPendingOrdersWithFilters(sl()));
  sl.registerLazySingleton(() => GetClients(sl()));
  sl.registerLazySingleton(() => GetExchanges(sl()));
  sl.registerLazySingleton(() => GetSymbols(sl()));
  sl.registerLazySingleton(() => GetOrderTypes(sl()));
  sl.registerLazySingleton(() => ExportToPdf(sl()));
  sl.registerLazySingleton(() => ExportToExcel(sl()));

  
  sl.registerLazySingleton<PendingOrdersRepository>(
    () => PendingOrdersRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<PendingOrdersRemoteDataSource>(
    () => PendingOrdersRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => TradesBloc(
      getTrades: sl(),
      getTradesWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getOrderTypes: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetTrades(sl()));
  sl.registerLazySingleton(() => GetTradesWithFilters(sl()));
  sl.registerLazySingleton(() => GetTradesClients(sl()));
  sl.registerLazySingleton(() => GetTradesExchanges(sl()));
  sl.registerLazySingleton(() => GetTradesSymbols(sl()));
  sl.registerLazySingleton(() => GetTradesOrderTypes(sl()));
  sl.registerLazySingleton(() => ExportTradesToPdf(sl()));
  sl.registerLazySingleton(() => ExportTradesToExcel(sl()));

  
  sl.registerLazySingleton<TradesRepository>(
    () => TradesRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<TradesRemoteDataSource>(
    () => TradesRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => DealsBloc(
      getDeals: sl(),
      getDealsWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getOrderTypes: sl(),
      getStatuses: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetDeals(sl()));
  sl.registerLazySingleton(() => GetDealsWithFilters(sl()));
  sl.registerLazySingleton(() => GetDealsClients(sl()));
  sl.registerLazySingleton(() => GetDealsExchanges(sl()));
  sl.registerLazySingleton(() => GetDealsSymbols(sl()));
  sl.registerLazySingleton(() => GetDealsOrderTypes(sl()));
  sl.registerLazySingleton(() => GetDealsStatuses(sl()));
  sl.registerLazySingleton(() => ExportDealsToPdf(sl()));
  sl.registerLazySingleton(() => ExportDealsToExcel(sl()));

  
  sl.registerLazySingleton<DealsRepository>(
    () => DealsRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<DealsRemoteDataSource>(
    () => DealsRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => NetPositionBloc(
      getNetPositions: sl(),
      getNetPositionsWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getUserTypes: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
      getPositionDetails: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetNetPositions(sl()));
  sl.registerLazySingleton(() => GetNetPositionsWithFilters(sl()));
  sl.registerLazySingleton(() => GetNetPositionClients(sl()));
  sl.registerLazySingleton(() => GetNetPositionExchanges(sl()));
  sl.registerLazySingleton(() => GetNetPositionSymbols(sl()));
  sl.registerLazySingleton(() => GetNetPositionUserTypes(sl()));
  sl.registerLazySingleton(() => ExportNetPositionsToPdf(sl()));
  sl.registerLazySingleton(() => ExportNetPositionsToExcel(sl()));
  sl.registerLazySingleton(() => GetPositionDetails(sl()));

  
  sl.registerLazySingleton<NetPositionRepository>(
    () => NetPositionRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<NetPositionRemoteDataSource>(
    () => NetPositionRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => RejectionLogBloc(
      getRejectionLogs: sl(),
      getRejectionLogsWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetRejectionLogs(sl()));
  sl.registerLazySingleton(() => GetRejectionLogsWithFilters(sl()));
  sl.registerLazySingleton(() => GetRejectionLogClients(sl()));
  sl.registerLazySingleton(() => GetRejectionLogExchanges(sl()));
  sl.registerLazySingleton(() => GetRejectionLogSymbols(sl()));
  sl.registerLazySingleton(() => ExportRejectionLogsToPdf(sl()));
  sl.registerLazySingleton(() => ExportRejectionLogsToExcel(sl()));

  
  sl.registerLazySingleton<RejectionLogRepository>(
    () => RejectionLogRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<RejectionLogRemoteDataSource>(
    () => RejectionLogRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => LoginHistoryBloc(
      getLoginHistory: sl(),
      getClients: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetLoginHistory(sl()));
  sl.registerLazySingleton(() => GetLoginHistoryClients(sl()));
  sl.registerLazySingleton(() => ExportLoginHistoryToPdf(sl()));
  sl.registerLazySingleton(() => ExportLoginHistoryToExcel(sl()));

  
  sl.registerLazySingleton<LoginHistoryRepository>(
    () => LoginHistoryRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<LoginHistoryRemoteDataSource>(
    () => LoginHistoryRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => ScriptMasterBloc(
      getScriptMasters: sl(),
      getScriptMastersWithFilters: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetScriptMasters(sl()));
  sl.registerLazySingleton(() => GetScriptMastersWithFilters(sl()));
  sl.registerLazySingleton(() => GetScriptMasterExchanges(sl()));
  sl.registerLazySingleton(() => GetScriptMasterSymbols(sl()));
  sl.registerLazySingleton(() => ExportScriptMastersToPdf(sl()));
  sl.registerLazySingleton(() => ExportScriptMastersToExcel(sl()));

  
  sl.registerLazySingleton<ScriptMasterRepository>(
    () => ScriptMasterRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<ScriptMasterRemoteDataSource>(
    () => ScriptMasterRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => ScriptQuantityBloc(
      getExchanges: sl(),
      getGroups: sl(),
      getScriptQuantities: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetScriptQuantityExchanges(sl()));
  sl.registerLazySingleton(() => GetScriptQuantityGroups(sl()));
  sl.registerLazySingleton(() => GetScriptQuantities(sl()));

  
  sl.registerLazySingleton<ScriptQuantityRepository>(
    () => ScriptQuantityRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<ScriptQuantityRemoteDataSource>(
    () => ScriptQuantityRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => IntradayHistoryBloc(
      getIntradayHistory: sl(),
      getIntradayHistoryInSeconds: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getTimings: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );

  
  sl.registerLazySingleton(() => GetIntradayHistory(sl()));
  sl.registerLazySingleton(() => GetIntradayHistoryInSeconds(sl()));
  sl.registerLazySingleton(() => GetIntradayExchanges(sl()));
  sl.registerLazySingleton(() => GetIntradaySymbols(sl()));
  sl.registerLazySingleton(() => GetIntradayTimings(sl()));
  sl.registerLazySingleton(() => GetAvailableTimeSlots(sl()));
  sl.registerLazySingleton(() => ExportIntradayToPdf(sl()));
  sl.registerLazySingleton(() => ExportIntradayToExcel(sl()));

  
  sl.registerLazySingleton<IntradayHistoryRepository>(
    () => IntradayHistoryRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<IntradayHistoryRemoteDataSource>(
    () => IntradayHistoryRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  
  
  

  
  sl.registerFactory(
    () => UserListBloc(
      getUsers: sl(),
      getUsersWithFilters: sl(),
      getUserTypes: sl(),
      getUserStatuses: sl(),
      exportUsersToPdf: sl(),
      exportUsersToExcel: sl(),
    ),
  );

  
  sl.registerFactory(
    () => InactiveUserListBloc(
      getUsers: sl(),
      getUsersWithFilters: sl(),
      getUserTypes: sl(),
      getUserStatuses: sl(),
      exportUsersToPdf: sl(),
      exportUsersToExcel: sl(),
    ),
  );

  
  sl.registerFactory(() => SearchUserBloc(getUsers: sl()));

  
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUsersWithFilters(sl()));
  sl.registerLazySingleton(() => GetUserTypes(sl()));
  sl.registerLazySingleton(() => GetUserStatuses(sl()));
  sl.registerLazySingleton(() => ExportUsersToPdf(sl()));
  sl.registerLazySingleton(() => ExportUsersToExcel(sl()));

  
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
}

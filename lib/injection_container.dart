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

final sl = GetIt.instance;

Future<void> init() async {
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
  // CORE
  // ============================================================

  // API Client
  sl.registerLazySingleton(() => ApiClient());
}
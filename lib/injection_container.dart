import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/market_watch/data/datasources/market_watch_local_datasource.dart';
import 'features/market_watch/data/repositories/market_watch_repository_impl.dart';
import 'features/market_watch/domain/repositories/market_watch_repository.dart';
import 'features/market_watch/domain/usecases/add_market_item.dart';
import 'features/market_watch/domain/usecases/delete_market_item.dart';
import 'features/market_watch/domain/usecases/get_market_items.dart';
import 'features/market_watch/presentation/bloc/marketwatch/market_watch_bloc.dart';
import 'features/market_watch/presentation/bloc/theme/theme_bloc.dart';
import 'features/market_watch/presentation/bloc/watchlist/watch_list_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Auth BLoC
  sl.registerFactory(() => AuthBloc(loginUser: sl()));
  sl.registerLazySingleton(() => LoginUser(repository: sl()));
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient());


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
}
import 'package:get_it/get_it.dart';
import 'features/market_watch/data/datasources/market_watch_local_datasource.dart';
import 'features/market_watch/data/repositories/market_watch_repository_impl.dart';
import 'features/market_watch/domain/repositories/market_watch_repository.dart';
import 'features/market_watch/domain/usecases/add_market_item.dart';
import 'features/market_watch/domain/usecases/delete_market_item.dart';
import 'features/market_watch/domain/usecases/get_market_items.dart';
import 'features/market_watch/presentation/bloc/market_watch_bloc.dart';

/// Dependency injection container
/// Uses get_it for service locator pattern
/// Registers all dependencies with proper lifecycle management
final sl = GetIt.instance;

/// Initialize all dependencies
/// Call this before running the app
Future<void> init() async {
  // BLoC
  // Register as factory so new instance is created each time
  sl.registerFactory(
    () => MarketWatchBloc(
      getMarketItems: sl(),
      addMarketItem: sl(),
      deleteMarketItem: sl(),
    ),
  );

  // Use cases
  // Register as lazy singleton for better performance
  sl.registerLazySingleton(() => GetMarketItems(sl()));
  sl.registerLazySingleton(() => AddMarketItem(sl()));
  sl.registerLazySingleton(() => DeleteMarketItem(sl()));

  // Repository
  // Register as lazy singleton as it manages data layer
  sl.registerLazySingleton<MarketWatchRepository>(
    () => MarketWatchRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  // Register as lazy singleton for data caching
  sl.registerLazySingleton<MarketWatchLocalDataSource>(
    () => MarketWatchLocalDataSourceImpl(),
  );
}

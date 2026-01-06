import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/market_watch/presentation/bloc/marketwatch/market_watch_bloc.dart';
import 'features/market_watch/presentation/bloc/theme/theme_bloc.dart';
import 'features/market_watch/presentation/bloc/watchlist/watch_list_bloc.dart';
import 'features/market_watch/presentation/pages/market_watch_page.dart';
import 'injection_container.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            // Auth BLoC
            BlocProvider(create: (_) => di.sl<AuthBloc>()),
            // Market Watch BLoC
            BlocProvider(create: (_) => di.sl<MarketWatchBloc>()),
            // Theme BLoC
            BlocProvider(create: (_) => di.sl<ThemeBloc>()),
            // Watchlist BLoC
            BlocProvider(create: (_) => di.sl<WatchlistBloc>()),
          ],
          child: MaterialApp(
            title: 'BAZAAR Pro',
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (_) => const LoginPage(),
              '/market-watch': (_) => const MarketWatchPage(),
            },
          ),
        );
      },
    );
  }
}
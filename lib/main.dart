import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:window_manager/window_manager.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/market_watch/presentation/bloc/arrangesymbol/arrange_symbol_bloc.dart';
import 'features/market_watch/presentation/bloc/market_depth/market_depth_bloc.dart';
import 'features/market_watch/presentation/bloc/marketwatch/market_watch_bloc.dart';
import 'features/market_watch/presentation/bloc/order/order_dialog_bloc.dart';
import 'features/market_watch/presentation/bloc/symbolfont/symbol_font_bloc.dart';
import 'features/market_watch/presentation/bloc/theme/theme_bloc.dart';
import 'features/market_watch/presentation/bloc/watchlist/watch_list_bloc.dart';
import 'features/view/presentation/bloc/login_history/login_history_bloc.dart';
import 'features/view/presentation/bloc/net_position/net_position_bloc.dart';
import 'features/view/presentation/bloc/pending_orders/pending_orders_bloc.dart';
import 'core/routes/app_routes.dart';
import 'features/view/presentation/bloc/rejection_log/rejection_log_bloc.dart';
import 'features/view/presentation/bloc/script_master/script_master_bloc.dart';
import 'features/view/presentation/bloc/script_quantity/script_quantity_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    // Get screen size
    final screenSize = await windowManager.getSize();
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate initial size (80% of screen size, but not exceeding 1920x1080)
    final initialWidth = (screenWidth * 0.7).clamp(1280.0, 1920.0);
    final initialHeight = (screenHeight * 0.7).clamp(720.0, 1080.0);

    final WindowOptions windowOptions = WindowOptions(
      // Dynamic initial window size based on screen
      size: Size(initialWidth, initialHeight),
      minimumSize: const Size(1280, 720),
      // No maximum size - let it grow with screen
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'BAZAAR Pro',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get actual window size
        final windowWidth = constraints.maxWidth > 0
            ? constraints.maxWidth
            : 1920.0;
        final windowHeight = constraints.maxHeight > 0
            ? constraints.maxHeight
            : 1080.0;

        return ScreenUtilInit(
          // Use actual window size for design size
          designSize: Size(windowWidth, windowHeight),
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

                // Theme BLoC - For dark/light mode toggle
                BlocProvider(create: (_) => di.sl<ThemeBloc>()),

                // Watchlist BLoC
                BlocProvider(create: (_) => di.sl<WatchlistBloc>()),

                // Arrange Symbol BLoC - For column arrangement
                BlocProvider(create: (_) => di.sl<ArrangeSymbolBloc>()),

                // Symbol Font BLoC - For font settings
                BlocProvider(create: (_) => di.sl<SymbolFontBloc>()),

                // Order Dialog BLoC - For Buy/Sell dialogs
                BlocProvider(create: (_) => di.sl<OrderDialogBloc>()),

                // Market Depth BLoC - For Market Depth dialog (F5)
                BlocProvider(create: (_) => di.sl<MarketDepthBloc>()),

                // Dashboard BLoC - For Dashboard charts and reports
                BlocProvider(create: (_) => di.sl<DashboardBloc>()),

                // Pending Orders BLoC - For View section pending orders
                BlocProvider(create: (_) => di.sl<PendingOrdersBloc>()),

                // Net Position BLoC - For View section net positions
                BlocProvider(create: (_) => di.sl<NetPositionBloc>()),

                // Net Position BLoC - For View section net positions
                BlocProvider(create: (_) => di.sl<RejectionLogBloc>()),

                BlocProvider(create: (_) => di.sl<LoginHistoryBloc>()),
                // Script Master BLoC - For View section script masters
                BlocProvider(create: (_) => di.sl<ScriptMasterBloc>()),
                // Script Quantity BLoC - For View section script quantities
                BlocProvider(create: (_) => di.sl<ScriptQuantityBloc>()),
              ],
              child: MaterialApp(
                title: 'BAZAAR Pro',
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.system,

                // Routing configuration
                initialRoute: AppRoutes.login,
                routes: AppRoutes.getRoutes(),
              ),
            );
          },
        );
      },
    );
  }
}
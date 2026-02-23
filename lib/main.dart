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
import 'features/view/presentation/bloc/intraday_history/intraday_history_bloc.dart';
import 'features/view/presentation/bloc/login_history/login_history_bloc.dart';
import 'features/view/presentation/bloc/net_position/net_position_bloc.dart';
import 'features/view/presentation/bloc/pending_orders/pending_orders_bloc.dart';
import 'core/routes/app_routes.dart';
import 'features/view/presentation/bloc/rejection_log/rejection_log_bloc.dart';
import 'features/view/presentation/bloc/script_master/script_master_bloc.dart';
import 'features/view/presentation/bloc/script_quantity/script_quantity_bloc.dart';
import 'features/users/presentation/bloc/user_list/user_list_bloc.dart';
import 'injection_container.dart' as di;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    final screenSize = await windowManager.getSize();
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final initialWidth = (screenWidth * 0.7).clamp(1280.0, 1920.0);
    final initialHeight = (screenHeight * 0.7).clamp(720.0, 1080.0);
    final WindowOptions windowOptions = WindowOptions(
      size: Size(initialWidth, initialHeight),
      minimumSize: const Size(1280, 720),
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
        final windowWidth = constraints.maxWidth > 0
            ? constraints.maxWidth
            : 1920.0;
        final windowHeight = constraints.maxHeight > 0
            ? constraints.maxHeight
            : 1080.0;
        return ScreenUtilInit(
          designSize: Size(windowWidth, windowHeight),
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          builder: (context, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => di.sl<AuthBloc>()),
                BlocProvider(create: (_) => di.sl<MarketWatchBloc>()),
                BlocProvider(create: (_) => di.sl<ThemeBloc>()),
                BlocProvider(create: (_) => di.sl<WatchlistBloc>()),
                BlocProvider(create: (_) => di.sl<ArrangeSymbolBloc>()),
                BlocProvider(create: (_) => di.sl<SymbolFontBloc>()),
                BlocProvider(create: (_) => di.sl<OrderDialogBloc>()),
                BlocProvider(create: (_) => di.sl<MarketDepthBloc>()),
                BlocProvider(create: (_) => di.sl<DashboardBloc>()),
                BlocProvider(create: (_) => di.sl<PendingOrdersBloc>()),
                BlocProvider(create: (_) => di.sl<NetPositionBloc>()),
                BlocProvider(create: (_) => di.sl<RejectionLogBloc>()),
                BlocProvider(create: (_) => di.sl<LoginHistoryBloc>()),
                BlocProvider(create: (_) => di.sl<ScriptMasterBloc>()),
                BlocProvider(create: (_) => di.sl<ScriptQuantityBloc>()),
                BlocProvider(create: (_) => di.sl<IntradayHistoryBloc>()),
                BlocProvider(create: (_) => di.sl<UserListBloc>()),
              ],
              child: MaterialApp(
                title: 'BAZAAR Pro',
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.system,
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

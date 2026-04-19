import 'package:flutter/material.dart';
import 'core/routes/navigator_key.dart';
import 'features/market_watch/presentation/widgets/global_escape_shortcut.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/bootstrap/app_initializer.dart';
import 'app/di/service_locator.dart';
import 'core/routes/app_routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
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
import 'features/view/presentation/bloc/rejection_log/rejection_log_bloc.dart';
import 'features/view/presentation/bloc/script_master/script_master_bloc.dart';
import 'features/view/presentation/bloc/script_quantity/script_quantity_bloc.dart';
import 'features/users/presentation/bloc/user_list/user_list_bloc.dart';
import 'core/observers/dialog_navigator_observer.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 1920.0;
        final windowHeight = constraints.maxHeight > 0 ? constraints.maxHeight : 1080.0;
        return ScreenUtilInit(
          designSize: Size(windowWidth, windowHeight),
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          builder: (context, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<AuthBloc>()),
                BlocProvider(create: (_) => sl<MarketWatchBloc>()),
                BlocProvider(create: (_) => sl<ThemeBloc>()),
                BlocProvider(create: (_) => sl<WatchlistBloc>()),
                BlocProvider(create: (_) => sl<ArrangeSymbolBloc>()),
                BlocProvider(create: (_) => sl<SymbolFontBloc>()),
                BlocProvider(create: (_) => sl<OrderDialogBloc>()),
                BlocProvider(create: (_) => sl<MarketDepthBloc>()),
                BlocProvider(create: (_) => sl<DashboardBloc>()),
                BlocProvider(create: (_) => sl<PendingOrdersBloc>()),
                BlocProvider(create: (_) => sl<NetPositionBloc>()),
                BlocProvider(create: (_) => sl<RejectionLogBloc>()),
                BlocProvider(create: (_) => sl<LoginHistoryBloc>()),
                BlocProvider(create: (_) => sl<ScriptMasterBloc>()),
                BlocProvider(create: (_) => sl<ScriptQuantityBloc>()),
                BlocProvider(create: (_) => sl<IntradayHistoryBloc>()),
                BlocProvider(create: (_) => sl<UserListBloc>()),
              ],
              child: GlobalEscapeShortcut(
                child: BlocListener<AuthBloc, AuthState>(
                  listenWhen: (previous, current) =>
                      current is AuthUnauthenticated &&
                      previous is AuthAuthenticated,
                  listener: (context, state) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                  child: MaterialApp(
                    navigatorKey: globalNavigatorKey,
                    title: 'BAZAAR Pro',
                    debugShowCheckedModeBanner: false,
                    themeMode: ThemeMode.system,
                    navigatorObservers: [DialogNavigatorObserver()],
                    initialRoute: AppRoutes.login,
                    routes: AppRoutes.getRoutes(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

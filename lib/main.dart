import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/market_watch/presentation/bloc/market_watch_bloc.dart';
import 'features/market_watch/presentation/pages/market_watch_page.dart';
import 'injection_container.dart' as di;

/// Main entry point of the application
/// Initializes dependencies and runs the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

/// Root widget of the application
/// Sets up theme, provides BLoCs, and configures routing
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<MarketWatchBloc>()),
      ],
      child: MaterialApp(
        title: 'BAZAAR Pro',
        debugShowCheckedModeBanner: false,

        // Light Theme with Google Fonts
        theme: AppTheme.lightTheme,

        // Dark Theme with Google Fonts
        darkTheme: AppTheme.darkTheme,

        // Use system theme mode
        themeMode: ThemeMode.system,

        // Routing configuration
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/market-watch': (context) => const MarketWatchPage(),
        },
      ),
    );
  }
}
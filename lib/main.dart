import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'features/market_watch/presentation/bloc/market_watch_bloc.dart';
import 'features/market_watch/presentation/pages/market_watch_page.dart';
import 'injection_container.dart' as di;

/// Main entry point of the application
/// Initializes dependencies and runs the app
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Run the app
  runApp(const MyApp());
}

/// Root widget of the application
/// Sets up theme and provides BLoC to widget tree
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Watch App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define app theme
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        
        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        
        // Text theme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.primaryTextColor),
          bodyMedium: TextStyle(color: AppColors.primaryTextColor),
        ),
        
        // Icon theme
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        
        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.darkNavy,
        ),
      ),
      home: BlocProvider(
        // Provide MarketWatchBloc to the widget tree
        create: (context) => di.sl<MarketWatchBloc>(),
        child: const MarketWatchPage(),
      ),
    );
  }
}

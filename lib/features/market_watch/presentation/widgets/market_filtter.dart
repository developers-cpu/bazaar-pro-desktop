import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/marketwatch/market_watch_bloc.dart';
import '../bloc/marketwatch/market_watch_event.dart';
import '../bloc/marketwatch/market_watch_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../bloc/theme/theme_state.dart';
import 'custom_filter_dropdown.dart';

class MarketFilters extends StatelessWidget {
  final MarketWatchLoaded state;

  const MarketFilters({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableSymbols = state.items.map((item) => item.symbol).toSet().toList()..sort();

    final exchanges = [
      AppStrings.nse,
      AppStrings.mcx,
      AppStrings.cePe,
      AppStrings.others,
      AppStrings.comex,
      AppStrings.crypto,
      AppStrings.gift,
      AppStrings.forex,
    ];

    return Container(
      width: double.infinity,
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomFilterDropdown(
                hintText: AppStrings.exchangeFilter,
                value: state.selectedExchange,
                items: exchanges,
                width: 250.w,
                dropdownHeight: 287.h,
                onChanged: (exchange) {
                  context.read<MarketWatchBloc>().add(FilterByExchangeEvent(exchange: exchange));
                },
              ),
              SizedBox(width: 16.w),
              CustomFilterDropdown(
                hintText: AppStrings.symbolFilter,
                value: state.selectedSymbol,
                items: availableSymbols,
                width: 250.w,
                onChanged: (symbol) {
                  context.read<MarketWatchBloc>().add(FilterBySymbolEvent(symbol: symbol));
                },
              ),
            ],
          ),
          _buildThemeToggle(context),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState.isDarkMode;

        return GestureDetector(
          onTap: () {
            context.read<ThemeBloc>().add(const ToggleThemeEvent());
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.primaryBlue : AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primaryBlue,
                width: 2.w,
              ),
            ),
            child: Center(
              child: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                size: 28.sp,
                color: isDarkMode ? AppColors.white : AppColors.primaryBlue,
              ),
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widget/svg_icon.dart';
import '../bloc/marketwatch/market_watch_bloc.dart';
import '../bloc/marketwatch/market_watch_event.dart';
import '../bloc/marketwatch/market_watch_state.dart';
import 'custom_filter_dropdown.dart';

class MarketFilters extends StatelessWidget {
  final MarketWatchLoaded state;

  const MarketFilters({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableSymbols = state.items
        .map((item) => item.symbol)
        .toSet()
        .toList()
      ..sort();

    // Exchange list
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
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Dropdowns
          Row(
            children: [
              // Exchange Dropdown
              CustomFilterDropdown(
                hintText: AppStrings.exchangeFilter,
                value: state.selectedExchange,
                items: exchanges,
                width: 250.w,
                dropdownHeight: 287.h,
                onChanged: (exchange) {
                  context.read<MarketWatchBloc>().add(
                    FilterByExchangeEvent(exchange: exchange),
                  );
                },
              ),

              SizedBox(width: 16.w),

              // Symbol Dropdown
              CustomFilterDropdown(
                hintText: AppStrings.symbolFilter,
                value: state.selectedSymbol,
                items: availableSymbols,
                width: 250.w,
                onChanged: (symbol) {
                  context.read<MarketWatchBloc>().add(
                    FilterBySymbolEvent(symbol: symbol),
                  );
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
    final bool isDarkMode = false;

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.themeToggleClicked),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: SizedBox(
        width: 50.w,
        height: 50.h,
        child: Center(
          child: SvgIcon(
            assetPath: AppImages.themeIcon,
            isActive: isDarkMode,
            size: 35.sp,
            activeColor: AppColors.primaryBlue,
            inactiveColor: AppColors.grey,
          ),
        ),
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_images.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';
import '../bloc/market_watch_state.dart';
import 'custom_filter_dropdown.dart';


class MarketFilters extends StatelessWidget {
  final MarketWatchLoaded state;

  const MarketFilters({
    Key? key,
    required this.state,
  }) : super(key: key);

  // ─────────────────────────────────────────────────────────────────
  // FIGMA DESIGN CONSTANTS
  // ─────────────────────────────────────────────────────────────────
  static const Color _primaryColor = Color(0xFF1F4A66);
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _primaryBgColor = Color(0x0D1F4A66);

  @override
  Widget build(BuildContext context) {
    // Get available symbols from state
    final availableSymbols = state.items
        .map((item) => item.symbol)
        .toSet()
        .toList()
      ..sort();

    // Exchange list
    final exchanges = [
      'NSE',
      'MCX',
      'CE/PE',
      'OTHERS',
      'COMEX',
      'CRYPTO',
      'GIFT',
      'FOREX',
    ];

    return Container(
      width: double.infinity,
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: const BoxDecoration(
        color: _backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Dropdowns
          Row(
            children: [
              // Exchange Dropdown
              CustomFilterDropdown(
                hintText: 'Exchange',
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
                hintText: 'Symbol',
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

          // Right side - Theme Toggle
          _buildThemeToggle(context),
        ],
      ),
    );
  }

  /// Theme toggle button - 40x40 with SVG icon
  Widget _buildThemeToggle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle theme toggle
        // You can implement your theme switching logic here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Theme toggle clicked'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 50.w,
        height: 50.h,
        child: Center(
          child: SvgPicture.asset(
            AppImages.themeIcon,
            width: 35.sp,
            height: 35.sp,
            colorFilter: const ColorFilter.mode(
              _primaryColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              Icons.brightness_6_outlined,
              color: _primaryColor,
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }
}
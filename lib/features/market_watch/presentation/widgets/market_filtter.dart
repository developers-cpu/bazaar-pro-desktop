import 'dart:async';
import 'package:intl/intl.dart';
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
import '../../../../core/widget/app_dropdown.dart';

class MarketFilters extends StatelessWidget {
  final MarketWatchLoaded state;
  final String? userRole;
  const MarketFilters({Key? key, required this.state, this.userRole})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    final symbolDisplayMap = <String, String>{};
    for (final item in state.items) {
      final label = item.expiry != null
          ? '${item.symbol} ${DateFormat('MMM dd').format(item.expiry!)}'
          : item.symbol;
      symbolDisplayMap[label] = item.symbol;
    }
    final displayLabels = symbolDisplayMap.keys.toList()..sort();
    final selectedDisplayLabels = (state.selectedSymbols ?? [])
        .map(
          (symbol) => symbolDisplayMap.entries
              .firstWhere(
                (e) => e.value == symbol,
                orElse: () => MapEntry(symbol, symbol),
              )
              .key,
        )
        .toList();
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
    final users = ['Client 1', 'Client 2', 'Client 3', 'Client 4', 'Client 5'];
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isCePe = state.selectedExchange == AppStrings.cePe;

        final expiries =
            state.items
                .where((i) => i.expiry != null)
                .map((i) => DateFormat('yy/MM/dd').format(i.expiry!))
                .toSet()
                .toList()
              ..sort();

        final prices =
            state.items
                .where((i) => i.strikePrice != null)
                .map((i) => i.strikePrice.toString())
                .toSet()
                .toList()
              ..sort((a, b) => double.parse(a).compareTo(double.parse(b)));

        final types = ['CALL', 'PUT'];

        return Container(
          width: double.infinity,
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(color: AppColors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppDropdown(
                        type: AppDropdownType.simple,
                        hintText: AppStrings.exchangeFilter,
                        value: state.selectedExchange,
                        items: exchanges,
                        width: 200.w,
                        dropdownHeight: 250.h,
                        onChanged: (exchange) {
                          context.read<MarketWatchBloc>().add(
                            FilterByExchangeEvent(
                              exchange: exchange?.isEmpty ?? true
                                  ? null
                                  : exchange,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10.w),
                      AppDropdown(
                        type: AppDropdownType.multiSelect,
                        hintText: AppStrings.symbolFilter,
                        selectedValues: selectedDisplayLabels,
                        items: displayLabels,
                        width: 200.w,
                        dropdownHeight: 250.h,
                        searchHint: 'Search & Add',
                        onMultiChanged: (selectedLabels) {
                          final symbols = selectedLabels
                              .map((label) => symbolDisplayMap[label] ?? label)
                              .toList();
                          context.read<MarketWatchBloc>().add(
                            FilterBySymbolsEvent(symbols: symbols),
                          );
                        },
                      ),
                      SizedBox(width: 10.w),
                      if (isCePe) ...[
                        AppDropdown(
                          type: AppDropdownType.simple,
                          hintText: 'Expiry',
                          value: state.selectedExpiry != null
                              ? DateFormat(
                                  'yy/MM/dd',
                                ).format(state.selectedExpiry!)
                              : null,
                          items: expiries,
                          width: 200.w,
                          dropdownHeight: 250.h,
                          onChanged: (val) {
                            DateTime? expiryDate;
                            if (val != null && val.isNotEmpty) {
                              try {
                                expiryDate = DateFormat('yy/MM/dd').parse(val);
                              } catch (_) {}
                            }
                            context.read<MarketWatchBloc>().add(
                              FilterByExpiryEvent(expiry: expiryDate),
                            );
                          },
                        ),
                        SizedBox(width: 10.w),
                        AppDropdown(
                          type: AppDropdownType.simple,
                          hintText: 'Type',
                          value: state.selectedType,
                          items: types,
                          width: 200.w,
                          dropdownHeight: 120.h,
                          onChanged: (val) {
                            context.read<MarketWatchBloc>().add(
                              FilterByTypeEvent(
                                type: val?.isEmpty == true ? null : val,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10.w),
                        AppDropdown(
                          type: AppDropdownType.search,
                          hintText: 'Price',
                          value: state.selectedPrice?.toString(),
                          items: prices,
                          width: 200.w,
                          dropdownHeight: 250.h,
                          searchHint: 'Search Price',
                          onChanged: (val) {
                            double? price;
                            if (val != null && val.isNotEmpty) {
                              price = double.tryParse(val);
                            }
                            context.read<MarketWatchBloc>().add(
                              FilterByPriceEvent(price: price),
                            );
                          },
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  if (userRole?.toLowerCase() == 'client')
                    const ClientProfitLossWidget()
                  else
                    AppDropdown(
                      type: AppDropdownType.search,
                      hintText: 'Username',
                      value: state.selectedUser,
                      items: users,
                      width: 200.w,
                      dropdownHeight: 280.h,
                      searchHint: 'Search & Add',
                      onChanged: (user) {
                        context.read<MarketWatchBloc>().add(
                          FilterByUserEvent(user: user),
                        );
                      },
                    ),
                  SizedBox(width: 10.w),
                  _buildThemeToggle(context),
                ],
              ),
            ],
          ),
        );
      },
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
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.primaryBlue : AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryBlue, width: 1.5),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  key: ValueKey<bool>(isDarkMode),
                  size: 20.sp,
                  color: isDarkMode ? AppColors.white : AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ClientProfitLossWidget extends StatefulWidget {
  const ClientProfitLossWidget({Key? key}) : super(key: key);

  @override
  State<ClientProfitLossWidget> createState() => _ClientProfitLossWidgetState();
}

class _ClientProfitLossWidgetState extends State<ClientProfitLossWidget> {
  double _profitLoss = 81400.00;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          final isPositive = (DateTime.now().second % 2 == 0);
          final mockChange = 500.0 + (DateTime.now().millisecond % 2000);
          if (isPositive) {
            _profitLoss = _profitLoss.abs() + mockChange;
          } else {
            _profitLoss = -(_profitLoss.abs() - mockChange);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('💰', style: TextStyle(fontSize: 20.sp)),
        SizedBox(width: 8.w),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            'P/L : ${_profitLoss.toStringAsFixed(2)}',
            key: ValueKey<double>(_profitLoss),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: _profitLoss >= 0
                  ? AppColors.buyColor
                  : AppColors.sellColor,
            ),
          ),
        ),
      ],
    );
  }
}

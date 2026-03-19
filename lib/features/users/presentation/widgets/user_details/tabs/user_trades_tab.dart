import 'package:bazarpro/core/widget/table/view_reset_buttons.dart';
import 'package:bazarpro/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../domain/entities/user_trades/user_trade.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../../../domain/entities/user.dart';
import '../../../bloc/user_trades/user_trades_bloc.dart';
import '../../../bloc/user_trades/user_trades_event.dart';
import '../../../bloc/user_trades/user_trades_state.dart';

class UserTradesTab extends StatelessWidget {
  final User user;
  const UserTradesTab({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserTradesBloc>()..add(LoadUserTrades(user.id)),
      child: const UserTradesTabView(),
    );
  }
}

class UserTradesTabView extends StatelessWidget {
  const UserTradesTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(context),
        _buildRecordCount(context),
        Expanded(child: _buildTable(context)),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: BlocBuilder<UserTradesBloc, UserTradesState>(
        builder: (context, state) {
          DateTimeRange? selectedDateRange;
          String? selectedExchange;
          String? selectedSymbol;
          String? selectedStatus;
          List<String> exchanges = [];
          List<String> symbols = [];
          if (state is UserTradesLoaded) {
            selectedDateRange = state.selectedDateRange;
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
            selectedStatus = state.selectedStatus;
            if (state.metadata != null) {
              exchanges = state.metadata!.exchanges;
              symbols = state.metadata!.symbols;
            }
          }
          final statuses = state is UserTradesLoaded && state.metadata != null
              ? state.metadata!.statuses
              : ['All'];
          return Row(
            children: [
              DateRangePickerButton(
                selectedDateRange: selectedDateRange,
                onTap: () {},
                onDateRangeSelected: (range) {
                  context.read<UserTradesBloc>().add(
                    FilterUserTrades(
                      dateRange: range,
                      exchange: selectedExchange,
                      symbol: selectedSymbol,
                      status: selectedStatus,
                    ),
                  );
                },
              ),
              SizedBox(width: 5.w),
              AppDropdown(
                hintText: 'Exchange',
                items: exchanges,
                value: selectedExchange,
                onChanged: (val) {
                  context.read<UserTradesBloc>().add(
                    FilterUserTrades(
                      dateRange: selectedDateRange,
                      exchange: val,
                      symbol: selectedSymbol,
                      status: selectedStatus,
                    ),
                  );
                },
                width: 160.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),
              SizedBox(width: 5.w),
              AppDropdown(
                hintText: 'Symbol',
                items: symbols,
                value: selectedSymbol,
                onChanged: (val) {
                  context.read<UserTradesBloc>().add(
                    FilterUserTrades(
                      dateRange: selectedDateRange,
                      exchange: selectedExchange,
                      symbol: val,
                      status: selectedStatus,
                    ),
                  );
                },
                width: 160.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
              ),
              SizedBox(width: 5.w),
              AppDropdown(
                hintText: 'Status',
                items: statuses,
                value: selectedStatus,
                onChanged: (val) {
                  context.read<UserTradesBloc>().add(
                    FilterUserTrades(
                      dateRange: selectedDateRange,
                      exchange: selectedExchange,
                      symbol: selectedSymbol,
                      status: val,
                    ),
                  );
                },
                width: 160.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),
              const Spacer(),
              ViewResetButtons(
                onReset: () {
                  context.read<UserTradesBloc>().add(
                    const FilterUserTrades(
                      dateRange: null,
                      exchange: null,
                      symbol: null,
                      status: null,
                    ),
                  );
                },
                onView: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecordCount(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: BlocBuilder<UserTradesBloc, UserTradesState>(
        builder: (context, state) {
          int count = 0;
          if (state is UserTradesLoaded) {
            count = state.filteredTrades.length;
          }
          return ViewRecordCount(count: count);
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<UserTradesBloc, UserTradesState>(
      builder: (context, state) {
        if (state is UserTradesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserTradesError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        List<UserTrade> trades = [];
        if (state is UserTradesLoaded) {
          trades = state.filteredTrades;
        }
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ViewDataTable<UserTrade>(
          columns: [
            ViewTableColumn(id: 'userName', label: 'U. NAME', width: 90.w),
            ViewTableColumn(id: 'parentUser', label: 'P USER', width: 90.w),
            ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80.w),
            ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 100.w),
            ViewTableColumn(id: 'buySell', label: 'B/S', width: 80.w),
            ViewTableColumn(id: 'tradeType', label: 'Trade Type', width: 100.w),
            ViewTableColumn(
              id: 'qty',
              label: 'QTY',
              width: 80.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'lot',
              label: 'LOT',
              width: 60.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'pnl',
              label: 'P/L',
              width: 70.w,
              isNumeric: true,
            ),
            ViewTableColumn(id: 'validity', label: 'VALIDITY', width: 90.w),
            ViewTableColumn(
              id: 'tradePrice',
              label: 'T. PRICE',
              width: 90.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'brk',
              label: 'BRK',
              width: 70.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'netPrice',
              label: 'NET P.',
              width: 80.w,
              isNumeric: true,
            ),
            ViewTableColumn(id: 'orderDt', label: 'Order D/T', width: 180.w),
            ViewTableColumn(id: 'execDt', label: 'Execution D/T', width: 180.w),
            ViewTableColumn(
              id: 'reqPrice',
              label: 'R. PRICE',
              width: 90.w,
              isNumeric: true,
            ),
            ViewTableColumn(
              id: 'duration',
              label: 'Order Duration',
              width: 150.w,
            ),
          ],
          data: trades,
          idExtractor: (item) => item.id,
          comparatorBuilder: (item, columnId) {
            switch (columnId) {
              case 'userName':
                return item.userName;
              case 'parentUser':
                return item.parentUser;
              case 'exchange':
                return item.exchange;
              case 'symbol':
                return item.symbol;
              case 'buySell':
                return item.buySell;
              case 'tradeType':
                return item.tradeType;
              case 'qty':
                return item.quantity;
              case 'lot':
                return item.lot;
              case 'pnl':
                return item.profitLoss;
              case 'validity':
                return item.validity;
              case 'tradePrice':
                return item.tradePrice;
              case 'brk':
                return item.brokerage;
              case 'netPrice':
                return item.netPrice;
              case 'orderDt':
                return item.orderTime;
              case 'execDt':
                return item.executionTime;
              case 'reqPrice':
                return item.requestPrice;
              default:
                return '';
            }
          },
          cellBuilder: (item, column) {
            switch (column.id) {
              case 'userName':
                return ViewTextCell(text: item.userName, isDark: isDark);
              case 'parentUser':
                return ViewTextCell(text: item.parentUser, isDark: isDark);
              case 'exchange':
                return ViewTextCell(text: item.exchange, isDark: isDark);
              case 'symbol':
                return ViewTextCell(text: item.symbol, isDark: isDark);
              case 'buySell':
                return ViewBuySellCell(text: item.buySell, isDark: isDark);
              case 'tradeType':
                return ViewTextCell(text: item.tradeType, isDark: isDark);
              case 'qty':
                return ViewNumberCell(
                  value: item.quantity,
                  colorByValue: true,
                  isDark: isDark,
                );
              case 'lot':
                return ViewNumberCell(
                  value: item.lot,
                  displayText: item.lot.toStringAsFixed(2),
                  colorByValue: false,
                  isDark: isDark,
                );
              case 'pnl':
                return ViewNumberCell(
                  value: item.profitLoss,
                  colorByValue: true,
                  isDark: isDark,
                );
              case 'validity':
                return ViewTextCell(text: item.validity, isDark: isDark);
              case 'tradePrice':
                return ViewNumberCell(
                  value: item.tradePrice,
                  fixedColor: AppColors.errorColor,
                  isDark: isDark,
                );
              case 'brk':
                return ViewNumberCell(
                  value: item.brokerage,
                  fixedColor: AppColors.errorColor,
                  isDark: isDark,
                );
              case 'netPrice':
                return ViewNumberCell(
                  value: item.netPrice,
                  fixedColor: AppColors.primaryBlue,
                  isDark: isDark,
                );
              case 'orderDt':
                return ViewDateTimeCell(
                  dateTime: item.orderTime,
                  isDark: isDark,
                  color: AppColors.errorColor,
                );
              case 'execDt':
                return ViewDateTimeCell(
                  dateTime: item.executionTime,
                  isDark: isDark,
                  color: AppColors.primaryBlue,
                );
              case 'reqPrice':
                return ViewNumberCell(
                  value: item.requestPrice,
                  fixedColor: AppColors.errorColor,
                  isDark: isDark,
                );
              case 'duration':
                return ViewLinkCell(
                  text: _formatDuration(item.orderDuration),
                  isDark: isDark,
                );
              default:
                return const SizedBox();
            }
          },
        );
      },
    );
  }

  String _formatDuration(String durationStr) {
    try {
      final parts = durationStr.split(':');
      if (parts.length != 3) return durationStr;
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;

      String result = "";
      if (hours > 0) {
        result += "$hours ${hours == 1 ? 'hour' : 'hours'} ";
      }
      result += "$minutes ${minutes == 1 ? 'minute' : 'minutes'}";
      return result.trim();
    } catch (e) {
      return durationStr;
    }
  }
}
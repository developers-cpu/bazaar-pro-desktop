import 'package:flutter/material.dart' hide DateRangePickerDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_trade.dart';
import '../../../bloc/user_trades/user_trades_bloc.dart';
import '../../../bloc/user_trades/user_trades_event.dart';
import '../../../bloc/user_trades/user_trades_state.dart';
import '../../common/user_data_table.dart';
import '../../common/user_record_count.dart';
import '../../common/user_reset_buttons.dart';

class UserTradesTab extends StatelessWidget {
  final User user;

  const UserTradesTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserTradesBloc()..add(LoadUserTrades(user.id)),
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

          if (state is UserTradesLoaded) {
            selectedDateRange = state.selectedDateRange;
            selectedExchange = state.selectedExchange;
            selectedSymbol = state.selectedSymbol;
            selectedStatus = state.selectedStatus;
          }

          return Row(
            children: [
              
              InkWell(
                onTap: () async {
                  final result = await DateRangePickerDialog.show(
                    context,
                    initialStartDate: selectedDateRange?.start,
                    initialEndDate: selectedDateRange?.end,
                  );
                  if (result != null) {
                    context.read<UserTradesBloc>().add(
                      FilterUserTrades(
                        dateRange: result,
                        exchange: selectedExchange,
                        symbol: selectedSymbol,
                        status: selectedStatus,
                      ),
                    );
                  }
                },
                child: Container(
                  height: 35.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryBlue),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        selectedDateRange != null
                            ? '${DateFormat('yyyy-MM-dd').format(selectedDateRange.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange.end)}'
                            : 'Select Date Range',
                        style: GoogleFonts.openSans(
                          fontSize: 12.sp,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.calendar_today,
                        size: 16.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              
              AppDropdown(
                hintText: 'Exchange',
                items: const ['NSE', 'MCX'],
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
                width: 120.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),
              SizedBox(width: 12.w),

              
              AppDropdown(
                hintText: 'Symbol',
                items: const [
                  'SGX GIFTNIFTY Oct 28',
                  'NSE NIFTY Oct 28',
                  'NSE BANKNIFTY Oct 28',
                  'MINI GOLDMINI Dec 05',
                  'MINI SILVERMINI Dec 05',
                  'OTHER DOW Dec 19',
                  'OTHER NASDAQ Dec 19',
                  'OTHER S & P Dec 19',
                ],
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
                width: 180.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
              ),
              SizedBox(width: 12.w),

              
              AppDropdown(
                hintText: 'Status',
                items: const [
                  'All',
                  'Market',
                  'Intraday',
                  'Settled',
                  'Pending to Success',
                  'Super Admin',
                ],
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
                width: 120.w,
                height: 35.h,
                type: AppDropdownType.simple,
              ),

              const Spacer(),
              UserResetButtons(
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
                onView: () {
                  
                },
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
          return UserRecordCount(count: count);
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

        return UserDataTable<UserTrade>(
          columns: [
            UserTableColumn(id: 'userName', label: 'U. NAME', width: 100.w),
            UserTableColumn(id: 'parentUser', label: 'P USER', width: 100.w),
            UserTableColumn(id: 'exchange', label: 'EXCH', width: 80.w),
            UserTableColumn(id: 'symbol', label: 'SYMBOL', width: 140.w),
            UserTableColumn(id: 'buySell', label: 'B/S', width: 80.w),
            UserTableColumn(id: 'tradeType', label: 'Trade Type', width: 100.w),
            UserTableColumn(
              id: 'qty',
              label: 'QTY',
              width: 80.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'lot',
              label: 'Lot',
              width: 60.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'pnl',
              label: 'P/L',
              width: 100.w,
              isNumeric: true,
            ),
            UserTableColumn(id: 'validity', label: 'Validity', width: 100.w),
            UserTableColumn(
              id: 'tradePrice',
              label: 'T. PRICE',
              width: 100.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'brk',
              label: 'Brk',
              width: 80.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'netPrice',
              label: 'NET P.',
              width: 100.w,
              isNumeric: true,
            ),
            UserTableColumn(id: 'orderDt', label: 'Order D/T', width: 140.w),
            UserTableColumn(id: 'execDt', label: 'Execution D/T', width: 140.w),
            UserTableColumn(
              id: 'reqPrice',
              label: 'R. PRICE',
              width: 100.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'duration',
              label: 'Order Duration',
              width: 120.w,
            ),
          ],
          data: trades,
          idExtractor: (item) => item.id,
          cellBuilder: (item, column) {
            switch (column.id) {
              case 'userName':
                return Text(item.userName, style: _cellStyle());
              case 'parentUser':
                return Text(item.parentUser, style: _cellStyle());
              case 'exchange':
                return Text(item.exchange, style: _cellStyle());
              case 'symbol':
                return Text(
                  item.symbol,
                  style: _cellStyle(
                    isSymbol: true,
                    color: AppColors.errorColor,
                  ),
                );
              case 'buySell':
                return Text(
                  item.buySell,
                  style: _cellStyle(
                    color: item.buySell == 'BUY'
                        ? AppColors.primaryBlue
                        : AppColors.errorColor,
                  ),
                );
              case 'tradeType':
                return Text(item.tradeType, style: _cellStyle());
              case 'qty':
                return Text(
                  item.quantity.toStringAsFixed(2),
                  style: _cellStyle(
                    color: item.quantity >= 0
                        ? AppColors.primaryBlue
                        : AppColors.errorColor,
                  ),
                );
              case 'lot':
                return Text(item.lot.toStringAsFixed(2), style: _cellStyle());
              case 'pnl':
                return Text(
                  item.profitLoss.toStringAsFixed(2),
                  style: _cellStyle(
                    color: item.profitLoss >= 0
                        ? AppColors.primaryBlue
                        : AppColors.errorColor,
                  ),
                );
              case 'validity':
                return Text(item.validity, style: _cellStyle());
              case 'tradePrice':
                return Text(
                  item.tradePrice.toStringAsFixed(2),
                  style: _cellStyle(color: AppColors.errorColor),
                );
              case 'brk':
                return Text(
                  item.brokerage.toStringAsFixed(2),
                  style: _cellStyle(color: AppColors.errorColor),
                );
              case 'netPrice':
                return Text(
                  item.netPrice.toStringAsFixed(2),
                  style: _cellStyle(),
                );
              case 'orderDt':
                return Text(
                  DateFormat('dd/MM/yy hh:mm:ss a').format(item.orderTime),
                  style: _cellStyle(
                    color: AppColors.errorColor,
                  ),
                );
              case 'execDt':
                return Text(
                  DateFormat('dd/MM/yy hh:mm:ss a').format(item.executionTime),
                  style: _cellStyle(
                    color:
                        AppColors.primaryBlue,
                  ),
                );
              case 'reqPrice':
                return Text(
                  item.requestPrice.toStringAsFixed(2),
                  style: _cellStyle(color: AppColors.errorColor),
                );
              case 'duration':
                return Text(
                  item.orderDuration,
                  style: _cellStyle(
                    isUnderline: true,
                    color: AppColors.primaryTextColor,
                  ),
                );
              default:
                return const SizedBox();
            }
          },
        );
      },
    );
  }

  TextStyle _cellStyle({
    Color? color,
    bool isSymbol = false,
    bool isUnderline = false,
  }) {
    return GoogleFonts.openSans(
      fontSize: 11.sp,
      fontWeight: isSymbol ? FontWeight.bold : FontWeight.w600,
      color:
          color, 
      decoration: isUnderline ? TextDecoration.underline : null,
    );
  }
}

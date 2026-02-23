import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:bazarpro/core/widget/date_range_picker_button.dart';
import 'package:bazarpro/core/widget/date_range_picker_dialog.dart' as custom;
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/symbol_wise_pl/trade_list/symbol_trade_list_bloc.dart';
import '../../bloc/symbol_wise_pl/trade_list/symbol_trade_list_event.dart';
import '../../bloc/symbol_wise_pl/trade_list/symbol_trade_list_state.dart';

class TradeListFilterBar extends StatelessWidget {
  const TradeListFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymbolTradeListBloc, SymbolTradeListState>(
      builder: (context, state) {
        if (state is! SymbolTradeListLoaded) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  DateRangePickerButton(
                    width: 200.w,
                    height: 40.h,
                    selectedDateRange: state.selectedDateRange,
                    onTap: () async {
                      final picked =
                          await custom.CustomDateRangePickerDialog.show(
                            context,
                            initialStartDate: state.selectedDateRange?.start,
                            initialEndDate: state.selectedDateRange?.end,
                          );
                      if (picked != null && context.mounted) {
                        context.read<SymbolTradeListBloc>().add(
                          FilterSymbolTradeList(dateRange: picked),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 12.w),
                  AppDropdown(
                    width: 150.w,
                    height: 40.h,
                    type: AppDropdownType.search,
                    hintText: 'User',
                    value: state.selectedUser,
                    items: state.users,
                    onChanged: (value) {
                      context.read<SymbolTradeListBloc>().add(
                        FilterSymbolTradeList(user: value),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  AppDropdown(
                    width: 150.w,
                    height: 40.h,
                    type: AppDropdownType.simple,
                    hintText: 'Exchange',
                    value: state.selectedExchange,
                    items: state.exchanges,
                    showAllOption: true,
                    onChanged: (value) {
                      context.read<SymbolTradeListBloc>().add(
                        FilterSymbolTradeList(exchange: value),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  AppDropdown(
                    width: 180.w,
                    height: 40.h,
                    type: AppDropdownType.search,
                    hintText: 'Symbol',
                    value: state.selectedSymbol,
                    items: state.symbols,
                    onChanged: (value) {
                      context.read<SymbolTradeListBloc>().add(
                        FilterSymbolTradeList(symbol: value),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  AppDropdown(
                    width: 150.w,
                    height: 40.h,
                    type: AppDropdownType.simple,
                    hintText: 'Select Type',
                    value: state.selectedType,
                    items: state.types,
                    onChanged: (value) {
                      context.read<SymbolTradeListBloc>().add(
                        FilterSymbolTradeList(type: value),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ViewResetButtons(
                    onReset: () {
                      context.read<SymbolTradeListBloc>().add(
                        const ResetSymbolTradeListFilters(),
                      );
                    },
                    onView: () {
                      context.read<SymbolTradeListBloc>().add(
                        FilterSymbolTradeList(
                          user: state.selectedUser,
                          exchange: state.selectedExchange,
                          symbol: state.selectedSymbol,
                          type: state.selectedType,
                          dateRange: state.selectedDateRange,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart' as custom;
import '../../../presentation/bloc/trade_log/trade_log_bloc.dart';
import '../../../presentation/bloc/trade_log/trade_log_event.dart';
import '../../../presentation/bloc/trade_log/trade_log_state.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class TradeLogFilterBar extends StatelessWidget {
  const TradeLogFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeLogBloc, TradeLogState>(
      builder: (context, state) {
        if (state is! TradeLogLoaded) {
          return const SizedBox.shrink();
        }
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              DateRangePickerButton(
                selectedDateRange: state.selectedDateRange,
                onTap: () async {
                  final picked = await custom.CustomDateRangePickerDialog.show(
                    context,
                    initialStartDate: state.selectedDateRange?.start,
                    initialEndDate: state.selectedDateRange?.end,
                  );
                  if (picked != null && context.mounted) {
                    context.read<TradeLogBloc>().add(
                      FilterTradeLogsEvent(dateRange: picked),
                    );
                  }
                },
              ),
              SizedBox(width: 12.w),
              if (!isClient) ...[
                AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'User',
                  value: state.selectedUser,
                  items: state.users,
                  width: 200.w,
                  height: 35.h,
                  onChanged: (value) {
                    context.read<TradeLogBloc>().add(
                      FilterTradeLogsEvent(user: value),
                    );
                  },
                ),
                SizedBox(width: 12.w),
              ],
              AppDropdown(
                type: AppDropdownType.simple,
                hintText: 'Exchange',
                value: state.selectedExchange,
                items: state.exchanges,
                showAllOption: true,
                width: 200.w,
                height: 35.h,
                onChanged: (value) {
                  context.read<TradeLogBloc>().add(
                    FilterTradeLogsEvent(exchange: value),
                  );
                },
              ),
              SizedBox(width: 12.w),
              AppDropdown(
                type: AppDropdownType.search,
                hintText: 'Symbol',
                value: state.selectedSymbol,
                items: state.symbols,
                width: 200.w,
                height: 35.h,
                onChanged: (value) {
                  context.read<TradeLogBloc>().add(
                    FilterTradeLogsEvent(symbol: value),
                  );
                },
              ),
              if (!isClient) ...[
                const Spacer(),
                ViewResetButtons(
                  onReset: () {
                    context.read<TradeLogBloc>().add(
                      const ResetTradeLogsFiltersEvent(),
                    );
                  },
                  onView: () {
                    context.read<TradeLogBloc>().add(
                      FilterTradeLogsEvent(
                        user: state.selectedUser,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                        dateRange: state.selectedDateRange,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/date_range_picker_button.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/rejection_log/rejection_log_bloc.dart';
import '../../bloc/rejection_log/rejection_log_event.dart';
import '../../bloc/rejection_log/rejection_log_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class RejectionLogFilterBar extends StatelessWidget {
  const RejectionLogFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RejectionLogBloc, RejectionLogState>(
      builder: (context, state) {
        if (state is! RejectionLogLoaded) {
          return const SizedBox.shrink();
        }
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';
        final isMaster =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'master';
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              if (!isMaster) ...[
                DateRangePickerButton(
                  width: 200.w,
                  selectedDateRange:
                      state.startDate != null && state.endDate != null
                      ? DateTimeRange(
                          start: state.startDate!,
                          end: state.endDate!,
                        )
                      : null,
                  onTap: () {},
                  onDateRangeSelected: (range) {
                    if (isClient) {
                      context.read<RejectionLogBloc>().add(
                        UpdateRejectionLogFiltersEvent(
                          startDate: range.start,
                          endDate: range.end,
                          client: state.selectedClient,
                          exchange: state.selectedExchange,
                          symbol: state.selectedSymbol,
                        ),
                      );
                    } else {
                      context.read<RejectionLogBloc>().add(
                        ApplyRejectionLogFiltersEvent(
                          startDate: range.start,
                          endDate: range.end,
                          client: state.selectedClient,
                          exchange: state.selectedExchange,
                          symbol: state.selectedSymbol,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(width: 12.w),
              ],
              if (!isClient) ...[
                SizedBox(
                  width: 200.w,
                  child: AppDropdown(
                    type: AppDropdownType.search,
                    hintText: 'Username',
                    value: state.selectedClient,
                    items: state.clients,
                    onChanged: (value) {
                      context.read<RejectionLogBloc>().add(
                        ApplyRejectionLogFiltersEvent(
                          startDate: state.startDate,
                          endDate: state.endDate,
                          client: value,
                          exchange: state.selectedExchange,
                          symbol: state.selectedSymbol,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  onChanged: (value) {
                    if (isClient) {
                      context.read<RejectionLogBloc>().add(
                        UpdateRejectionLogFiltersEvent(
                          startDate: state.startDate,
                          endDate: state.endDate,
                          client: state.selectedClient,
                          exchange: value,
                          symbol: state.selectedSymbol,
                        ),
                      );
                    } else {
                      context.read<RejectionLogBloc>().add(
                        ApplyRejectionLogFiltersEvent(
                          startDate: state.startDate,
                          endDate: state.endDate,
                          client: state.selectedClient,
                          exchange: value,
                          symbol: state.selectedSymbol,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'Symbol',
                  value: state.selectedSymbol,
                  items: state.symbols,
                  onChanged: (value) {
                    if (isClient) {
                      context.read<RejectionLogBloc>().add(
                        UpdateRejectionLogFiltersEvent(
                          startDate: state.startDate,
                          endDate: state.endDate,
                          client: state.selectedClient,
                          exchange: state.selectedExchange,
                          symbol: value,
                        ),
                      );
                    } else {
                      context.read<RejectionLogBloc>().add(
                        ApplyRejectionLogFiltersEvent(
                          startDate: state.startDate,
                          endDate: state.endDate,
                          client: state.selectedClient,
                          exchange: state.selectedExchange,
                          symbol: value,
                        ),
                      );
                    }
                  },
                ),
              ),
              const Spacer(),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  context.read<RejectionLogBloc>().add(
                    const ResetRejectionLogFiltersEvent(),
                  );
                },
                onView: () {
                  context.read<RejectionLogBloc>().add(
                    ApplyRejectionLogFiltersEvent(
                      startDate: state.startDate,
                      endDate: state.endDate,
                      client: state.selectedClient,
                      exchange: state.selectedExchange,
                      symbol: state.selectedSymbol,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:bazarpro/core/widget/date_range_picker_button.dart';
import 'package:bazarpro/core/widget/table/view_reset_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_bloc.dart';
import '../../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_event.dart';
import '../../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class UserWiseProfitAndLossFilterBar extends StatelessWidget {
  const UserWiseProfitAndLossFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    return BlocBuilder<UserWiseProfitAndLossBloc, UserWiseProfitAndLossState>(
      builder: (context, state) {
        String? selectedUser;
        DateTimeRange? selectedDateRange;
        List<String> users = [];
        if (state is UserWiseProfitAndLossLoaded) {
          selectedUser = state.selectedUser;
          users = state.userNames;
          if (state.startDate != null && state.endDate != null) {
            selectedDateRange = DateTimeRange(
              start: DateTime.parse(state.startDate!),
              end: DateTime.parse(state.endDate!),
            );
          }
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              AppDropdown(
                value: selectedUser,
                hintText: 'Username',
                items: users,
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
                onChanged: (value) {
                  context.read<UserWiseProfitAndLossBloc>().add(
                    FilterUserWiseProfitAndLoss(
                      userId: value,
                      startDate: state is UserWiseProfitAndLossLoaded
                          ? state.startDate
                          : null,
                      endDate: state is UserWiseProfitAndLossLoaded
                          ? state.endDate
                          : null,
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              DateRangePickerButton(
                width: 200.w,
                height: 35.h,
                selectedDateRange: selectedDateRange,
                onTap: () {},
                onDateRangeSelected: (range) {
                  context.read<UserWiseProfitAndLossBloc>().add(
                    FilterUserWiseProfitAndLoss(
                      startDate: range.start.toIso8601String(),
                      endDate: range.end.toIso8601String(),
                      userId: selectedUser,
                    ),
                  );
                },
              ),
              const Spacer(),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  context.read<UserWiseProfitAndLossBloc>().add(
                    const ResetUserWiseProfitAndLossFilters(),
                  );
                },
                onView: () {
                  context.read<UserWiseProfitAndLossBloc>().add(
                    FilterUserWiseProfitAndLoss(
                      userId: selectedUser,
                      startDate: selectedDateRange?.start.toIso8601String(),
                      endDate: selectedDateRange?.end.toIso8601String(),
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
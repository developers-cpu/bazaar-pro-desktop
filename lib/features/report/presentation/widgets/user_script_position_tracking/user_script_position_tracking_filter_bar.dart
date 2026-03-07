import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../bloc/user_script_position_tracking/user_script_position_tracking_bloc.dart';
import '../../bloc/user_script_position_tracking/user_script_position_tracking_event.dart';
import '../../bloc/user_script_position_tracking/user_script_position_tracking_state.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class UserScriptPositionTrackingFilterBar extends StatelessWidget {
  const UserScriptPositionTrackingFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return BlocBuilder<
      UserScriptPositionTrackingBloc,
      UserScriptPositionTrackingState
    >(
      builder: (context, state) {
        String? selectedUser;
        String? selectedExchange;
        String? selectedSymbol;
        DateTimeRange? selectedDateRange;
        List<String> userNames = [];
        List<String> exchanges = [];
        List<String> symbols = [];
        if (state is UserScriptPositionTrackingLoaded) {
          selectedUser = state.selectedUser;
          selectedExchange = state.selectedExchange;
          selectedSymbol = state.selectedSymbol;
          userNames = state.userNames;
          exchanges = state.exchanges;
          symbols = state.symbols;
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              DateRangePickerButton(
                width: 200.w,
                height: 35.h,
                selectedDateRange: selectedDateRange,
                onTap: () {},
                onDateRangeSelected: (range) {
                  context.read<UserScriptPositionTrackingBloc>().add(
                    FilterUserScriptPositionTracking(
                      startDate: range.start.toIso8601String(),
                      endDate: range.end.toIso8601String(),
                      userId: selectedUser,
                      exchange: selectedExchange,
                      symbol: selectedSymbol,
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              AppDropdown(
                value: selectedUser,
                hintText: 'User',
                items: userNames,
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
                onChanged: (value) {
                  context.read<UserScriptPositionTrackingBloc>().add(
                    FilterUserScriptPositionTracking(
                      startDate: state is UserScriptPositionTrackingLoaded
                          ? state.startDate
                          : null,
                      endDate: state is UserScriptPositionTrackingLoaded
                          ? state.endDate
                          : null,
                      userId: value,
                      exchange: selectedExchange,
                      symbol: selectedSymbol,
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              AppDropdown(
                value: selectedExchange,
                hintText: 'Exchange',
                items: exchanges,
                width: 200.w,
                height: 35.h,
                onChanged: (value) {
                  context.read<UserScriptPositionTrackingBloc>().add(
                    FilterUserScriptPositionTracking(
                      startDate: state is UserScriptPositionTrackingLoaded
                          ? state.startDate
                          : null,
                      endDate: state is UserScriptPositionTrackingLoaded
                          ? state.endDate
                          : null,
                      userId: selectedUser,
                      exchange: value,
                      symbol: selectedSymbol,
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              AppDropdown(
                value: selectedSymbol,
                hintText: 'Symbol',
                items: symbols,
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.search,
                onChanged: (value) {
                  context.read<UserScriptPositionTrackingBloc>().add(
                    FilterUserScriptPositionTracking(
                      startDate: state is UserScriptPositionTrackingLoaded
                          ? state.startDate
                          : null,
                      endDate: state is UserScriptPositionTrackingLoaded
                          ? state.endDate
                          : null,
                      userId: selectedUser,
                      exchange: selectedExchange,
                      symbol: value,
                    ),
                  );
                },
              ),
              const Spacer(),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  context.read<UserScriptPositionTrackingBloc>().add(
                    const ResetUserScriptPositionTrackingFilters(),
                  );
                },
                onView: () {
                  context.read<UserScriptPositionTrackingBloc>().add(
                    FilterUserScriptPositionTracking(
                      startDate: state is UserScriptPositionTrackingLoaded
                          ? state.startDate
                          : null,
                      endDate: state is UserScriptPositionTrackingLoaded
                          ? state.endDate
                          : null,
                      userId: selectedUser,
                      exchange: selectedExchange,
                      symbol: selectedSymbol,
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

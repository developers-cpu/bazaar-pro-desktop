import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/rejected_trade/rejected_trade_bloc.dart';
import '../../bloc/rejected_trade/rejected_trade_event.dart';
import '../../bloc/rejected_trade/rejected_trade_state.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class RejectedTradeFilterBar extends StatelessWidget {
  const RejectedTradeFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RejectedTradeBloc, RejectedTradeState>(
      builder: (context, state) {
        if (state is! RejectedTradeLoaded) {
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
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'User Type',
                  value: state.selectedUserType,
                  items: state.userTypes,
                  onChanged: (value) {
                    context.read<RejectedTradeBloc>().add(
                      ApplyRejectedTradeFiltersEvent(
                        userType: value,
                        user: state.selectedUser,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'User',
                  value: state.selectedUser,
                  items: state.users,
                  onChanged: (value) {
                    context.read<RejectedTradeBloc>().add(
                      ApplyRejectedTradeFiltersEvent(
                        userType: state.selectedUserType,
                        user: value,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Exchange',
                  value: state.selectedExchange,
                  items: state.exchanges,
                  onChanged: (value) {
                    context.read<RejectedTradeBloc>().add(
                      ApplyRejectedTradeFiltersEvent(
                        userType: state.selectedUserType,
                        user: state.selectedUser,
                        exchange: value,
                        symbol: state.selectedSymbol,
                      ),
                    );
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
                    context.read<RejectedTradeBloc>().add(
                      ApplyRejectedTradeFiltersEvent(
                        userType: state.selectedUserType,
                        user: state.selectedUser,
                        exchange: state.selectedExchange,
                        symbol: value,
                      ),
                    );
                  },
                ),
              ),
              if (!isClient) ...[
                const Spacer(),
                ViewResetButtons(
                  onReset: () {
                    context.read<RejectedTradeBloc>().add(
                      const ResetRejectedTradeFiltersEvent(),
                    );
                  },
                  onView: () {
                    context.read<RejectedTradeBloc>().add(
                      ApplyRejectedTradeFiltersEvent(
                        userType: state.selectedUserType,
                        user: state.selectedUser,
                        exchange: state.selectedExchange,
                        symbol: state.selectedSymbol,
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

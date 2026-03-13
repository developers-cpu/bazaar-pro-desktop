import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/credit_history/credit_history_bloc.dart';
import '../../bloc/credit_history/credit_history_event.dart';
import '../../bloc/credit_history/credit_history_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class CreditHistoryFilterBar extends StatelessWidget {
  const CreditHistoryFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditHistoryBloc, CreditHistoryState>(
      builder: (context, state) {
        if (state is! CreditHistoryLoaded) {
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
              AppDropdown(
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.simple,
                hintText: 'User Type',
                value: state.selectedType,
                items: const ['Master', 'Client'],
                onChanged: (value) {
                  context.read<CreditHistoryBloc>().add(
                    CreditHistoryFilter(type: value),
                  );
                },
              ),
              SizedBox(width: 12.w),
              AppDropdown(
                width: 200.w,
                height: 35.h,
                type: AppDropdownType.search,
                hintText: 'Username',
                searchHint: 'Search & Add',
                value: state.selectedUser,
                items: state.users,
                onChanged: (value) {
                  context.read<CreditHistoryBloc>().add(
                    CreditHistoryFilter(user: value),
                  );
                },
              ),
              const Spacer(),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  context.read<CreditHistoryBloc>().add(
                    const ResetCreditHistoryFilters(),
                  );
                },
                onView: () {
                  context.read<CreditHistoryBloc>().add(
                    FilterCreditHistory(
                      user: state.selectedUser,
                      type: state.selectedType,
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

import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/profit_and_loss_report/profit_and_loss_report_bloc.dart';
import '../../bloc/profit_and_loss_report/profit_and_loss_report_event.dart';
import '../../bloc/profit_and_loss_report/profit_and_loss_report_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class ProfitAndLossFilterBar extends StatelessWidget {
  const ProfitAndLossFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return BlocBuilder<ProfitAndLossReportBloc, ProfitAndLossReportState>(
      builder: (context, state) {
        String? selectedUser;
        List<String> users = [];
        if (state is ProfitAndLossReportLoaded) {
          selectedUser = state.selectedUser;
          users = state.userNames;
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
                type: AppDropdownType.search,
                searchHint: 'Search & Add',
                onChanged: (value) {
                  context.read<ProfitAndLossReportBloc>().add(
                    FilterProfitAndLossReport(userId: value),
                  );
                },
              ),
              const Spacer(),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  context.read<ProfitAndLossReportBloc>().add(
                    const ResetProfitAndLossReportFilters(),
                  );
                },
                onView: () {
                  if (selectedUser != null) {
                    context.read<ProfitAndLossReportBloc>().add(
                      FilterProfitAndLossReport(userId: selectedUser),
                    );
                  } else {
                    context.read<ProfitAndLossReportBloc>().add(
                      const ResetProfitAndLossReportFilters(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

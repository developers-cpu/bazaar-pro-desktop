import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/login_history/login_history_bloc.dart';
import '../../bloc/login_history/login_history_event.dart';
import '../../bloc/login_history/login_history_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class LoginHistoryFilterBar extends StatelessWidget {
  const LoginHistoryFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';

    return BlocBuilder<LoginHistoryBloc, LoginHistoryState>(
      builder: (context, state) {
        final clients = state is LoginHistoryInitial
            ? state.clients
            : state is LoginHistoryLoaded
            ? state.clients
            : <String>[];
        final selectedClient = state is LoginHistoryInitial
            ? state.selectedClient
            : state is LoginHistoryLoaded
            ? state.selectedClient
            : null;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'User Type',
                  items: const ['Master', 'Client'],
                  onChanged: (value) {},
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.search,
                  hintText: 'User',
                  value: selectedClient,
                  items: clients,
                  onChanged: (value) {
                    if (value != null && value.isNotEmpty) {
                      context.read<LoginHistoryBloc>().add(
                        SelectClientEvent(value),
                      );
                    }
                  },
                ),
              ),
              const Spacer(),
              ViewResetButtons(
                showReset: !isClient,
                onReset: () {
                  context.read<LoginHistoryBloc>().add(
                    const ResetLoginHistoryEvent(),
                  );
                },
                onView: () {
                  context.read<LoginHistoryBloc>().add(
                    const ViewLoginHistoryEvent(),
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

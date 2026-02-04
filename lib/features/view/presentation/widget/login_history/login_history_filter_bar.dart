import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../bloc/login_history/login_history_bloc.dart';
import '../../bloc/login_history/login_history_event.dart';
import '../../bloc/login_history/login_history_state.dart';
class LoginHistoryFilterBar extends StatelessWidget {
  const LoginHistoryFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginHistoryBloc, LoginHistoryState>(
      builder: (context, state) {
        final clients = state is LoginHistoryInitial
            ? state.clients
            : state is LoginHistoryLoaded
            ? state.clients
            : <String>[];
        final selectedClient = state is LoginHistoryLoaded ? state.selectedClient : null;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              SizedBox(
                width: 200.w,
                child: AppDropdown(
                  type: AppDropdownType.simple,
                  hintText: 'Select Client',
                  value: selectedClient,
                  items: clients,
                  onChanged: (value) {
                    if (value != null && value.isNotEmpty) {
                      context.read<LoginHistoryBloc>().add(SelectClientEvent(value));
                    }
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}

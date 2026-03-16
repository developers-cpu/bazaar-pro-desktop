import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../../injection_container.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../bloc/login_history/login_history_bloc.dart';
import '../../bloc/login_history/login_history_event.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'login_history_table.dart';

class LoginHistoryDialog {
  static void show(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String username = '';
    if (authState is AuthAuthenticated) {
      username = authState.user.username;
    }
    CommonDialog.show(
      context: context,
      title: 'Login History',
      width: 800.w,
      height: 600.h,
      backgroundColor: Colors.white,
      showButtons: false,
      scrollable: false,
      content: BlocProvider(
        create: (context) {
          final bloc = sl<LoginHistoryBloc>();
          bloc.add(SelectClientEvent(username));
          bloc.add(const ViewLoginHistoryEvent());
          return bloc;
        },
        child: const _LoginHistoryContent(),
      ),
    );
  }
}

class _LoginHistoryContent extends StatelessWidget {
  const _LoginHistoryContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(height: 500.h, child: const LoginHistoryTable());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../injection_container.dart';
import '../../bloc/credit_history/credit_history_bloc.dart';
import '../../bloc/credit_history/credit_history_event.dart';
import '../../bloc/credit_history/credit_history_state.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'credit_history_filter_bar.dart';
import 'credit_history_table.dart';

class CreditHistoryDialog {
  static void show(BuildContext context, {VoidCallback? onClose}) {
    CommonDialog.show(
      context: context,
      title: 'Credit History',
      width: 900.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      onClose: onClose,
      content: BlocProvider(
        create: (_) {
          final bloc = sl<CreditHistoryBloc>();
          bloc.add(const LoadCreditHistory());
          return bloc;
        },
        child: const _CreditHistoryContent(),
      ),
    );
  }
}

class _CreditHistoryContent extends StatelessWidget {
  const _CreditHistoryContent();
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    return Column(
      children: [
        SizedBox(height: 16.h),
        if (!isClient) const CreditHistoryFilterBar(isDialogMode: true),
        SizedBox(height: 8.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BlocBuilder<CreditHistoryBloc, CreditHistoryState>(
              builder: (context, state) {
                if (state is CreditHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const CreditHistoryTable();
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

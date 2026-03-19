import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/trade_margin/trade_margin_bloc.dart';
import '../../bloc/trade_margin/trade_margin_event.dart';
import '../../bloc/trade_margin/trade_margin_state.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'trade_margin_filter_bar.dart';
import 'trade_margin_table.dart';

class TradeMarginDialog {
  static void show(BuildContext context, {VoidCallback? onClose}) {
    CommonDialog.show(
      context: context,
      title: 'Trade Margin',
      width: 800.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      onClose: onClose,
      content: BlocProvider(
        create: (_) {
          final bloc = sl<TradeMarginBloc>();
          bloc.add(const LoadTradeMargins());
          return bloc;
        },
        child: const _TradeMarginContent(),
      ),
    );
  }
}

class _TradeMarginContent extends StatelessWidget {
  const _TradeMarginContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        const TradeMarginFilterBar(isDialogMode: true),
        SizedBox(height: 8.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BlocBuilder<TradeMarginBloc, TradeMarginState>(
              builder: (context, state) {
                final authState = context.read<AuthBloc>().state;
                final isClient =
                    authState is AuthAuthenticated &&
                    authState.user.role.toLowerCase() == 'client';
                if (state is TradeMarginLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TradeMarginLoaded) {
                  return TradeMarginTable(
                    tradeMargins: state.tradeMargins,
                    isClient: isClient,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
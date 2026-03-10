import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/trade_margin/trade_margin_bloc.dart';
import '../../bloc/trade_margin/trade_margin_event.dart';
import '../../bloc/trade_margin/trade_margin_state.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import 'trade_margin_filter_bar.dart';
import 'trade_margin_table.dart';

class TradeMarginDialog extends StatelessWidget {
  const TradeMarginDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => BlocProvider(
        create: (_) {
          final bloc = sl<TradeMarginBloc>();
          bloc.add(const LoadTradeMargins());
          return bloc;
        },
        child: const TradeMarginDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Trade Margin',
      width: 800.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
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
                    if (state.showDialog) {
                      return TradeMarginTable(
                        tradeMargins: state.tradeMargins,
                        isClient: isClient,
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

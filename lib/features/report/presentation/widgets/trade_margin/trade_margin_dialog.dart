import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/trade_margin/trade_margin_bloc.dart';
import '../../bloc/trade_margin/trade_margin_event.dart';
import '../../bloc/trade_margin/trade_margin_state.dart';
import 'trade_margin_filter_bar.dart';
import 'trade_margin_table.dart';

class TradeMarginDialog extends StatelessWidget {
  const TradeMarginDialog({super.key});

  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Trade Margin',
      width: 1000.w,
      height: 700.h,
      showButtons: false,
      contentPadding: EdgeInsets.zero,
      scrollable: false,
      content: const TradeMarginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TradeMarginBloc>()..add(const LoadTradeMargins()),
      child: Column(
        children: [
          const TradeMarginFilterBar(),
          Expanded(
            child: BlocBuilder<TradeMarginBloc, TradeMarginState>(
              builder: (context, state) {
                if (state is TradeMarginLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TradeMarginLoaded) {
                  return Column(
                    children: [Expanded(child: const TradeMarginTable())],
                  );
                } else if (state is TradeMarginError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

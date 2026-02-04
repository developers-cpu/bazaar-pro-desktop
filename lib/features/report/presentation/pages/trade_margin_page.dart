import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../bloc/trade_margin/trade_margin_bloc.dart';
import '../bloc/trade_margin/trade_margin_event.dart';
import '../bloc/trade_margin/trade_margin_state.dart';
import '../widgets/trade_margin/trade_margin_filter_bar.dart';
import '../widgets/trade_margin/trade_margin_table.dart';

class TradeMarginPage extends StatelessWidget {
  const TradeMarginPage({super.key});

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

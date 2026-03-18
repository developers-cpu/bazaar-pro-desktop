import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:bazarpro/injection_container.dart';
import 'package:bazarpro/features/view/presentation/bloc/trade/trades_bloc.dart';
import 'package:bazarpro/features/view/presentation/bloc/trade/trades_event.dart';
import 'package:bazarpro/features/view/presentation/bloc/trade/trades_state.dart';
import 'package:bazarpro/features/view/presentation/widget/trade/trades_filter_bar.dart';
import 'package:bazarpro/features/view/presentation/widget/trade/trades_table.dart';

class TradeDialog extends StatelessWidget {
  final String? exchange;
  final String? symbol;
  final String? userName;

  const TradeDialog({Key? key, this.exchange, this.symbol, this.userName})
    : super(key: key);

  static void show(
    BuildContext context, {
    String? exchange,
    String? symbol,
    String? userName,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Trade',
      width: 1300.w,
      height: 700.h,
      content: TradeDialog(
        exchange: exchange,
        symbol: symbol,
        userName: userName,
      ),
      showButtons: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TradesBloc>()
        ..add(const LoadTradesEvent())
        ..add(
          ApplyFiltersEvent(
            exchange: exchange,
            symbol: symbol,
            client: userName,
          ),
        ),
      child: BlocBuilder<TradesBloc, TradesState>(
        builder: (context, state) {
          return SizedBox(
            height: 600.h,
            child: const Column(
              children: [
                TradesFilterBar(),
                Expanded(child: TradesTable(showDeviceInfo: true)),
              ],
            ),
          );
        },
      ),
    );
  }
}

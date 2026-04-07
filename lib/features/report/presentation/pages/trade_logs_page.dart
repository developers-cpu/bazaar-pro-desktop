import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/trade_log/trade_log_filter_bar.dart';
import '../widgets/trade_log/trade_log_table.dart';

class TradeLogsPage extends StatelessWidget {
  const TradeLogsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          const TradeLogFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TradeLogTable(),
            ),
          ),
        ],
      ),
    );
  }
}

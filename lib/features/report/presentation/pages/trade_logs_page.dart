import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../injection_container.dart' as di;
import '../../../../../core/constants/app_colors.dart';
import '../bloc/trade_log/trade_log_bloc.dart';
import '../bloc/trade_log/trade_log_event.dart';
import '../widgets/trade_log/trade_log_filter_bar.dart';
import '../widgets/trade_log/trade_log_table.dart';

class TradeLogsPage extends StatelessWidget {
  const TradeLogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<TradeLogBloc>()..add(const LoadTradeLogsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            const TradeLogFilterBar(),
            Divider(height: 1.h, color: AppColors.grey.withOpacity(0.2)),
            const Expanded(child: TradeLogTable()),
          ],
        ),
      ),
    );
  }
}

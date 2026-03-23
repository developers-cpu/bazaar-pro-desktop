import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/rejected_trade/rejected_trade_bloc.dart';
import '../../bloc/rejected_trade/rejected_trade_event.dart';
import '../../bloc/rejected_trade/rejected_trade_state.dart';
import '../../widget/rejected_trade/rejected_trade_filter_bar.dart';
import '../../widget/rejected_trade/rejected_trade_table.dart';

class RejectedTradePage extends StatefulWidget {
  const RejectedTradePage({Key? key}) : super(key: key);
  @override
  State<RejectedTradePage> createState() => _RejectedTradePageState();
}

class _RejectedTradePageState extends State<RejectedTradePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RejectedTradeBloc>().add(const LoadRejectedTradesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RejectedTradeBloc, RejectedTradeState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const RejectedTradeFilterBar(),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RejectedTradeTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, RejectedTradeState state) {
    if (state is RejectedTradeExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is RejectedTradeError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

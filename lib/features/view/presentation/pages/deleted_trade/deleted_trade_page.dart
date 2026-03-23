import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/deleted_trade/deleted_trade_bloc.dart';
import '../../bloc/deleted_trade/deleted_trade_event.dart';
import '../../bloc/deleted_trade/deleted_trade_state.dart';
import '../../widget/deleted_trade/deleted_trade_filter_bar.dart';
import '../../widget/deleted_trade/deleted_trade_table.dart';

class DeletedTradePage extends StatefulWidget {
  const DeletedTradePage({Key? key}) : super(key: key);
  @override
  State<DeletedTradePage> createState() => _DeletedTradePageState();
}

class _DeletedTradePageState extends State<DeletedTradePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeletedTradeBloc>().add(const LoadDeletedTradesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeletedTradeBloc, DeletedTradeState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const DeletedTradeFilterBar(),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: DeletedTradeTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, DeletedTradeState state) {
    if (state is DeletedTradeExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is DeletedTradeError) {
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

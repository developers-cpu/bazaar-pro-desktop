import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/trade/trades_bloc.dart';
import '../../bloc/trade/trades_event.dart';
import '../../bloc/trade/trades_state.dart';
import '../../widget/trade/trades_filter_bar.dart';
import '../../widget/trade/trades_table.dart';

class TradesPage extends StatefulWidget {
  const TradesPage({Key? key}) : super(key: key);
  @override
  State<TradesPage> createState() => _TradesPageState();
}

class _TradesPageState extends State<TradesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TradesBloc>().add(const LoadTradesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TradesBloc, TradesState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const TradesFilterBar(),
            const Expanded(child: TradesTable(showDeviceInfo: true)),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, TradesState state) {
    if (state is TradesExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is TradesError) {
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

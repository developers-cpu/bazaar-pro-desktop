import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/pending_orders/pending_orders_bloc.dart';
import '../../bloc/pending_orders/pending_orders_event.dart';
import '../../bloc/pending_orders/pending_orders_state.dart';
import '../../widget/pending_orders/pending_orders_filter_bar.dart';
import '../../widget/pending_orders/pending_orders_table.dart';
class PendingOrdersPage extends StatefulWidget {
  const PendingOrdersPage({Key? key}) : super(key: key);
  @override
  State<PendingOrdersPage> createState() => _PendingOrdersPageState();
}
class _PendingOrdersPageState extends State<PendingOrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingOrdersBloc>().add(const LoadPendingOrdersEvent());
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<PendingOrdersBloc, PendingOrdersState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const PendingOrdersFilterBar(),
            const Expanded(child: PendingOrdersTable(showDeviceInfo: false)),
          ],
        ),
      ),
    );
  }
  void _handleStateChange(BuildContext context, PendingOrdersState state) {
    if (state is PendingOrdersExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is PendingOrdersError) {
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

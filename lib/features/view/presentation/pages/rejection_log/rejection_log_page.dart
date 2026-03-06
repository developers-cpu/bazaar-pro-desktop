import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/rejection_log/rejection_log_bloc.dart';
import '../../bloc/rejection_log/rejection_log_event.dart';
import '../../bloc/rejection_log/rejection_log_state.dart';
import '../../widget/rejection_log/rejection_log_filter_bar.dart';
import '../../widget/rejection_log/rejection_log_table.dart';

class RejectionLogPage extends StatefulWidget {
  const RejectionLogPage({Key? key}) : super(key: key);
  @override
  State<RejectionLogPage> createState() => _RejectionLogPageState();
}

class _RejectionLogPageState extends State<RejectionLogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RejectionLogBloc>().add(const LoadRejectionLogsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RejectionLogBloc, RejectionLogState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const RejectionLogFilterBar(),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RejectionLogTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, RejectionLogState state) {
    if (state is RejectionLogExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is RejectionLogError) {
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

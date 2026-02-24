import 'package:bazarpro/features/report/presentation/bloc/profit_and_loss_report/profit_and_loss_report_bloc.dart';
import 'package:bazarpro/features/report/presentation/bloc/profit_and_loss_report/profit_and_loss_report_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../widgets/profit_and_loss_report/profit_and_loss_filter_bar.dart';
import '../widgets/profit_and_loss_report/profit_and_loss_report_table.dart';

class ProfitAndLossReportPage extends StatelessWidget {
  const ProfitAndLossReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProfitAndLossReportBloc>()..add(const LoadProfitAndLossReport()),
      child: Column(
        children: [
          const ProfitAndLossFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const ProfitAndLossReportTable(),
            ),
          ),
        ],
      ),
    );
  }
}

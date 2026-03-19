import 'package:flutter/material.dart';
import '../widgets/profit_and_loss_report/profit_and_loss_filter_bar.dart';
import '../widgets/profit_and_loss_report/profit_and_loss_report_table.dart';

class ProfitAndLossReportPage extends StatelessWidget {
  const ProfitAndLossReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfitAndLossFilterBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const ProfitAndLossReportTable(),
          ),
        ),
      ],
    );
  }
}
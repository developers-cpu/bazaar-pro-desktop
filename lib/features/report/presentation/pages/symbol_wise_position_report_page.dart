import 'package:flutter/material.dart';
import '../widgets/symbol_wise_pl_report/symbol_wise_position_report_filter_bar.dart';
import '../widgets/symbol_wise_pl_report/symbol_wise_position_report_table.dart';

class SymbolWisePositionReportPage extends StatelessWidget {
  const SymbolWisePositionReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SymbolWisePositionReportFilterBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const SymbolWisePositionReportTable(),
          ),
        ),
      ],
    );
  }
}

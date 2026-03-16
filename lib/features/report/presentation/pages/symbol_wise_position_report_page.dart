import 'package:bazarpro/features/report/presentation/bloc/symbol_wise_position_report/symbol_wise_position_report_bloc.dart';
import 'package:bazarpro/features/report/presentation/bloc/symbol_wise_position_report/symbol_wise_position_report_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../widgets/symbol_wise_pl_report/symbol_wise_position_report_filter_bar.dart';
import '../widgets/symbol_wise_pl_report/symbol_wise_position_report_table.dart';
class SymbolWisePositionReportPage extends StatelessWidget {
  const SymbolWisePositionReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SymbolWisePositionReportBloc>()
            ..add(const LoadSymbolWisePositionReport()),
      child: Column(
        children: [
          const SymbolWisePositionReportFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const SymbolWisePositionReportTable(),
            ),
          ),
        ],
      ),
    );
  }
}

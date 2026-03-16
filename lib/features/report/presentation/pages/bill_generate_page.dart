import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bill_generate/bill_generate_bloc.dart';
import '../bloc/bill_generate/bill_generate_state.dart';
import '../widgets/bill_generate/bill_generate_filter_bar.dart';
import '../widgets/bill_generate/bill_generate_view.dart';
import '../utils/bill_export_service.dart';
class BillGeneratePage extends StatelessWidget {
  const BillGeneratePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BillGenerateFilterBar(),
        Expanded(
          child: BlocConsumer<BillGenerateBloc, BillGenerateState>(
            listener: (context, state) {
              if (state is BillGenerateLoaded && state.shouldExport) {
                final format = state.selectedBillFormat?.toLowerCase() ?? 'pdf';
                if (format == 'excel') {
                  BillExportService.exportAsExcel(state.report, billType: state.selectedBillType);
                } else {
                  BillExportService.exportAsPdf(state.report, billType: state.selectedBillType);
                }
              }
            },
            builder: (context, state) {
              if (state is BillGenerateLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BillGenerateLoaded) {
                return BillGenerateView(
                  report: state.report,
                  billType: state.selectedBillType,
                );
              } else if (state is BillGenerateError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../bloc/bill_generate/bill_generate_bloc.dart';
import '../bloc/bill_generate/bill_generate_event.dart';
import '../bloc/bill_generate/bill_generate_state.dart';
import '../widgets/bill_generate/bill_generate_filter_bar.dart';
import '../widgets/bill_generate/bill_generate_view.dart';
class BillGeneratePage extends StatelessWidget {
  const BillGeneratePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BillGenerateBloc>()..add(const LoadBillGenerateReport()),
      child: Column(
        children: [
          const BillGenerateFilterBar(),
          Expanded(
            child: BlocBuilder<BillGenerateBloc, BillGenerateState>(
              builder: (context, state) {
                if (state is BillGenerateLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BillGenerateLoaded) {
                  return BillGenerateView(report: state.report);
                } else if (state is BillGenerateError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

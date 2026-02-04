import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_bloc.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_event.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_state.dart';
import '../widgets/exchange_wise_pl/exchange_wise_pl_table.dart';

class ExchangeWisePLReportPage extends StatelessWidget {
  const ExchangeWisePLReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ExchangeWisePLBloc>()..add(const LoadExchangeWisePL()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ExchangeWisePLBloc, ExchangeWisePLState>(
                builder: (context, state) {
                  if (state is ExchangeWisePLLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ExchangeWisePLLoaded) {
                    return ExchangeWisePLTable(reports: state.reports);
                  } else if (state is ExchangeWisePLError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_bloc.dart';
import '../bloc/exchange_wise_pl/exchange_wise_pl_state.dart';
import '../widgets/exchange_wise_pl/exchange_wise_pl_table.dart';

class ExchangeWisePLReportPage extends StatelessWidget {
  const ExchangeWisePLReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ExchangeWisePLBloc, ExchangeWisePLState>(
              builder: (context, state) {
                if (state is ExchangeWisePLLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExchangeWisePLLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ExchangeWisePLTable(reports: state.reports),
                  );
                } else if (state is ExchangeWisePLError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

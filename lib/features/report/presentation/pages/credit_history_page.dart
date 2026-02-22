import 'package:bazarpro/features/report/presentation/bloc/credit_history/credit_history_bloc.dart';
import 'package:bazarpro/features/report/presentation/bloc/credit_history/credit_history_event.dart';
import 'package:bazarpro/features/report/presentation/widgets/credit_history/credit_history_filter_bar.dart';
import 'package:bazarpro/features/report/presentation/widgets/credit_history/credit_history_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';

class CreditHistoryPage extends StatelessWidget {
  const CreditHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreditHistoryBloc>()..add(const LoadCreditHistory()),
      child: Column(
        children: [
          const CreditHistoryFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const CreditHistoryTable(),
            ),
          ),
        ],
      ),
    );
  }
}

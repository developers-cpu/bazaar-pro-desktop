import 'package:bazarpro/features/report/presentation/widgets/credit_history/credit_history_filter_bar.dart';
import 'package:bazarpro/features/report/presentation/widgets/credit_history/credit_history_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class CreditHistoryPage extends StatelessWidget {
  const CreditHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    return Column(
      children: [
        if (!isClient) const CreditHistoryFilterBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const CreditHistoryTable(),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../bloc/symbol_wise_pl/symbol_wise_pl_bloc.dart';
import '../bloc/symbol_wise_pl/symbol_wise_pl_event.dart';
import '../widgets/symbol_wise_pl_report/symbol_wise_pl_filter_bar.dart';
import '../widgets/symbol_wise_pl_report/symbol_wise_pl_table.dart';
import '../widgets/symbol_wise_pl_report/client_symbol_wise_pl_table.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class SymbolWisePLReportPage extends StatelessWidget {
  const SymbolWisePLReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    return BlocProvider(
      create: (_) => sl<SymbolWisePLBloc>()..add(const LoadSymbolWisePL()),
      child: Column(
        children: [
          const SymbolWisePLFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isClient
                  ? const ClientSymbolWisePLTable()
                  : const SymbolWisePLTable(),
            ),
          ),
        ],
      ),
    );
  }
}

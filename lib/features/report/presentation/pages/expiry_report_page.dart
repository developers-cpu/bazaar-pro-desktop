import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import 'report_page_wrapper.dart';
import '../bloc/expiry_report/expiry_report_bloc.dart';
import '../bloc/expiry_report/expiry_report_event.dart';
import '../widgets/expiry_report/expiry_report_filter_bar.dart';
import '../widgets/expiry_report/expiry_report_table.dart';

class ExpiryReportPageWithAppBar extends StatelessWidget {
  const ExpiryReportPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpiryReportBloc>()..add(const LoadExpiryReport()),
      child: const ReportPageWrapper(
        pageTitle: 'Expiry Report',
        child: _ExpiryReportPage(),
      ),
    );
  }
}

class _ExpiryReportPage extends StatelessWidget {
  const _ExpiryReportPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpiryReportFilterBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const ExpiryReportTable(),
          ),
        ),
      ],
    );
  }
}

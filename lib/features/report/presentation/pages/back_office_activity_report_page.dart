import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/back_office_activity_report/back_office_activity_report_bloc.dart';
import '../bloc/back_office_activity_report/back_office_activity_report_event.dart';
import '../widgets/back_office_activity_report/back_office_activity_report_table.dart';

class BackOfficeActivityReportPage extends StatelessWidget {
  const BackOfficeActivityReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BackOfficeActivityReportBloc>()
            ..add(const LoadBackOfficeActivityReport()),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: BackOfficeActivityReportTable(),
      ),
    );
  }
}

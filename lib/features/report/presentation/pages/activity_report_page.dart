import 'package:bazarpro/features/report/presentation/bloc/activity_report/activity_report_bloc.dart';
import 'package:bazarpro/features/report/presentation/bloc/activity_report/activity_report_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../widgets/activity_report/activity_report_filter_bar.dart';
import '../widgets/activity_report/activity_report_table.dart';
class ActivityReportPage extends StatelessWidget {
  const ActivityReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActivityReportBloc>()..add(const LoadActivityReport()),
      child: Column(
        children: [
          const ActivityReportFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const ActivityReportTable(),
            ),
          ),
        ],
      ),
    );
  }
}

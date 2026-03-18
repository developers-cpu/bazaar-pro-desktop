import 'package:flutter/material.dart';
import '../widgets/activity_report/activity_report_filter_bar.dart';
import '../widgets/activity_report/activity_report_table.dart';

class ActivityReportPage extends StatelessWidget {
  const ActivityReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ActivityReportFilterBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const ActivityReportTable(),
          ),
        ),
      ],
    );
  }
}

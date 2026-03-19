import 'package:flutter/material.dart';
import '../widgets/back_office_activity_report/back_office_activity_report_table.dart';

class BackOfficeActivityReportPage extends StatelessWidget {
  const BackOfficeActivityReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: BackOfficeActivityReportTable(),
    );
  }
}
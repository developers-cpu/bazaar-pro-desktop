import 'package:flutter/material.dart';
import '../widgets/user_script_position_tracking/user_script_position_tracking_filter_bar.dart';
import '../widgets/user_script_position_tracking/user_script_position_tracking_table.dart';

class UserScriptPositionTrackingPage extends StatelessWidget {
  const UserScriptPositionTrackingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserScriptPositionTrackingFilterBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const UserScriptPositionTrackingTable(),
          ),
        ),
      ],
    );
  }
}

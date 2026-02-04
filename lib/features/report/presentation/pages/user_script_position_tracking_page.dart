import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../bloc/user_script_position_tracking/user_script_position_tracking_bloc.dart';
import '../bloc/user_script_position_tracking/user_script_position_tracking_event.dart';
import '../widgets/user_script_position_tracking/user_script_position_tracking_filter_bar.dart';
import '../widgets/user_script_position_tracking/user_script_position_tracking_table.dart';
class UserScriptPositionTrackingPage extends StatelessWidget {
  const UserScriptPositionTrackingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserScriptPositionTrackingBloc>()
            ..add(const LoadUserScriptPositionTracking()),
      child: Column(
        children: [
          const UserScriptPositionTrackingFilterBar(),
          Expanded(child: const UserScriptPositionTrackingTable()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/script_master/script_master_bloc.dart';
import '../../bloc/script_master/script_master_event.dart';
import '../../bloc/script_master/script_master_state.dart';
import '../../widget/script_master/script_master_filter_bar.dart';
import '../../widget/script_master/script_master_table.dart';
class ScriptMasterPage extends StatefulWidget {
  const ScriptMasterPage({Key? key}) : super(key: key);
  @override
  State<ScriptMasterPage> createState() => _ScriptMasterPageState();
}
class _ScriptMasterPageState extends State<ScriptMasterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScriptMasterBloc>().add(const LoadScriptMastersEvent());
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ScriptMasterBloc, ScriptMasterState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const ScriptMasterFilterBar(),
            Container(
              height: 1.h,
              color: AppColors.greyBorder,
            ),
            const Expanded(
              child: ScriptMasterTable(),
            ),
          ],
        ),
      ),
    );
  }
  void _handleStateChange(BuildContext context, ScriptMasterState state) {
    if (state is ScriptMasterExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is ScriptMasterError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

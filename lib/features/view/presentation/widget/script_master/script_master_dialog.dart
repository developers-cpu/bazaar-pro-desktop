import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/script_master/script_master_bloc.dart';
import '../../bloc/script_master/script_master_event.dart';
import '../../bloc/script_master/script_master_state.dart';
import 'script_master_filter_bar.dart';
import 'script_master_table.dart';

class ScriptMasterDialog {
  static void show(BuildContext context, {VoidCallback? onClose}) {
    CommonDialog.show(
      context: context,
      title: 'Script Master',
      width: 800.w,
      height: 750.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      onClose: onClose,
      content: BlocProvider(
        create: (_) {
          final bloc = sl<ScriptMasterBloc>();
          bloc.add(const LoadScriptMastersEvent());
          return bloc;
        },
        child: const _ScriptMasterContent(),
      ),
    );
  }
}

class _ScriptMasterContent extends StatelessWidget {
  const _ScriptMasterContent();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        const ScriptMasterFilterBar(isDialogMode: true),
        SizedBox(height: 8.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BlocBuilder<ScriptMasterBloc, ScriptMasterState>(
              builder: (context, state) {
                if (state is ScriptMasterLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ScriptMasterLoaded) {
                  return ScriptMasterTable();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

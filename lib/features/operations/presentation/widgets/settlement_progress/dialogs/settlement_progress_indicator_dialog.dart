import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../bloc/settlement_progress/settlement_progress_bloc.dart';
import '../../../bloc/settlement_progress/settlement_progress_state.dart';
import '../../../bloc/settlement_progress/settlement_progress_event.dart';

class SettlementProgressIndicatorDialog {
  static void show(BuildContext context, {SettlementProgressBloc? bloc}) {
    CommonDialog.show(
      context: context,
      title: 'Settlement',
      width: 700.w,
      height: 250.h,
      showButtons: false,
      contentPadding: EdgeInsets.all(30.w),
      contentBuilder: (context, onClose) {
        final content = _SettlementProgressIndicatorContent(onClose: onClose);
        if (bloc != null) {
          return BlocProvider.value(value: bloc, child: content);
        }
        return content;
      },
    );
  }
}

class _SettlementProgressIndicatorContent extends StatelessWidget {
  final VoidCallback onClose;
  const _SettlementProgressIndicatorContent({Key? key, required this.onClose})
    : super(key: key);
  void _onView(BuildContext context) {
    context.read<SettlementProgressBloc>().add(LoadSettlementDataEvent());
    onClose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementProgressBloc, SettlementProgressState>(
      builder: (context, state) {
        final isCompleted = state is SettlementCompleted;
        final bloc = context.read<SettlementProgressBloc>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  Text(
                    bloc.currentExchange,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: isCompleted ? 1.0 : null,
                        minHeight: 12.h,
                        backgroundColor: AppColors.borderColor,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    isCompleted ? 'Completed' : 'Updating...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            if (isCompleted)
              CustomActionButton(
                text: 'View',
                onPressed: () => _onView(context),
                width: 100.w,
                height: 40.h,
              )
            else
              SizedBox(height: 40.h),
          ],
        );
      },
    );
  }
}

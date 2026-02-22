import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_step_indicator.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../injection_container.dart';
import '../../bloc/user_form/user_form_bloc.dart';
import '../../bloc/user_form/user_form_event.dart';
import '../../bloc/user_form/user_form_state.dart';
import 'shared/personal_details_step.dart';
import 'client_steps/client_exchange_allow_step.dart';
import 'shared/high_low_limit_step.dart';
import 'shared/brokerage_setting_step.dart';
import 'client_steps/client_trigger_settings_step.dart';
import 'shared/profile_summary_dialog.dart';

class MastersClientFormDialog extends StatelessWidget {
  final bool isEditMode;
  final Map<String, dynamic>? userData;
  final VoidCallback? onComplete;
  const MastersClientFormDialog({
    super.key,
    this.isEditMode = false,
    this.userData,
    this.onComplete,
  });
  static void showCreate({
    required BuildContext context,
    VoidCallback? onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => BlocProvider(
        create: (_) => sl<UserFormBloc>()
          ..add(
            const InitializeFormEvent(
              isEditMode: false,
              userType: "Master's Client",
            ),
          ),
        child: MastersClientFormDialog(
          isEditMode: false,
          onComplete: onComplete,
        ),
      ),
    );
  }

  static void showEdit({
    required BuildContext context,
    required Map<String, dynamic> userData,
    VoidCallback? onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => BlocProvider(
        create: (_) => sl<UserFormBloc>()
          ..add(
            InitializeFormEvent(
              isEditMode: true,
              userType: "Master's Client",
              userData: userData,
            ),
          ),
        child: MastersClientFormDialog(
          isEditMode: true,
          userData: userData,
          onComplete: onComplete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserFormBloc, UserFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
          onComplete?.call();
        }
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: 580.w,
            constraints: BoxConstraints(maxHeight: 600.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, state),
                _buildStepIndicator(state),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: _buildStepContent(state),
                  ),
                ),
                _buildNavigationButtons(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, UserFormState state) {
    final title = state.isEditMode
        ? "Edit Master's Client"
        : "Create Master's Client";
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 45.h,
        color: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, size: 24.sp, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(UserFormState state) {
    return AppStepIndicator(
      currentStep: state.currentStep,
      totalSteps: 5,
      stepTitles: UserFormState.mastersClientStepTitles,
    );
  }

  Widget _buildStepContent(UserFormState state) {
    switch (state.currentStep) {
      case 0:
        return const PersonalDetailsStep();
      case 1:
        return const ClientExchangeAllowStep();
      case 2:
        return const HighLowLimitStep();
      case 3:
        return const ClientTriggerSettingsStep();
      case 4:
        return const BrokerageSettingStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(BuildContext context, UserFormState state) {
    final isLastStep = state.currentStep == 4;
    final isFirstStep = state.currentStep == 0;
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          if (!isFirstStep) ...[
            Expanded(
              child: CustomActionButton(
                text: 'Back',
                height: 35.h,
                borderRadius: 8.r,
                onPressed: () =>
                    context.read<UserFormBloc>().add(const PreviousStepEvent()),
              ),
            ),
            SizedBox(width: 16.w),
          ],
          Expanded(
            child: CustomActionButton(
              text: isLastStep ? 'Preview' : 'Next',
              height: 35.h,
              borderRadius: 8.r,
              onPressed: () {
                if (isLastStep) {
                  ProfileSummaryDialog.show(context);
                } else {
                  context.read<UserFormBloc>().add(const NextStepEvent());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

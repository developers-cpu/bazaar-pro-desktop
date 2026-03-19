import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_step_indicator.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../injection_container.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import '../../bloc/user_form/user_form_bloc.dart';
import '../../bloc/user_form/user_form_event.dart';
import '../../bloc/user_form/user_form_state.dart';
import 'shared/personal_details_step.dart';
import 'master_steps/master_exchange_allow_step.dart';
import 'master_steps/master_exchange_setting_table_step.dart';
import 'shared/high_low_limit_step.dart';
import 'shared/brokerage_setting_step.dart';
import 'master_steps/pnl_sharing_step.dart';
import 'master_steps/master_trigger_settings_step.dart';
import 'shared/profile_summary_dialog.dart';

class MasterFormDialog extends StatelessWidget {
  final bool isEditMode;
  final Map<String, dynamic>? userData;
  final VoidCallback? onComplete;
  const MasterFormDialog({
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
            const InitializeFormEvent(isEditMode: false, userType: 'Master'),
          ),
        child: MasterFormDialog(isEditMode: false, onComplete: onComplete),
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
              userType: 'Master',
              userData: userData,
            ),
          ),
        child: MasterFormDialog(
          isEditMode: true,
          userData: userData,
          onComplete: onComplete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _isAdminRole(context);
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
                _buildStepIndicator(isAdmin, state),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: _buildStepContent(isAdmin, state),
                  ),
                ),
                _buildNavigationButtons(context, isAdmin, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, UserFormState state) {
    final title = state.isEditMode ? 'Edit Master' : 'Create Master';
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

  bool _isAdminRole(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.role == 'Admin';
    }
    return false;
  }

  List<String> _getStepTitles(bool isAdmin) {
    if (isAdmin) return UserFormState.masterStepTitles;
    return UserFormState.masterStepTitles
        .where((t) => t != 'Exchange Setting')
        .toList();
  }

  int _getTotalSteps(bool isAdmin) {
    return isAdmin ? 7 : 6;
  }

  Widget _buildStepIndicator(bool isAdmin, UserFormState state) {
    return AppStepIndicator(
      currentStep: state.currentStep,
      totalSteps: _getTotalSteps(isAdmin),
      stepTitles: _getStepTitles(isAdmin),
    );
  }

  Widget _buildStepContent(bool isAdmin, UserFormState state) {
    if (isAdmin) {
      switch (state.currentStep) {
        case 0:
          return const PersonalDetailsStep();
        case 1:
          return const PnlSharingStep();
        case 2:
          return const MasterExchangeAllowStep();
        case 3:
          return const MasterExchangeSettingTableStep();
        case 4:
          return const HighLowLimitStep();
        case 5:
          return const MasterTriggerSettingsStep();
        case 6:
          return const BrokerageSettingStep();
        default:
          return const SizedBox.shrink();
      }
    } else {
      switch (state.currentStep) {
        case 0:
          return const PersonalDetailsStep();
        case 1:
          return const PnlSharingStep();
        case 2:
          return const MasterExchangeAllowStep();
        case 3:
          return const HighLowLimitStep();
        case 4:
          return const MasterTriggerSettingsStep();
        case 5:
          return const BrokerageSettingStep();
        default:
          return const SizedBox.shrink();
      }
    }
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    bool isAdmin,
    UserFormState state,
  ) {
    final totalSteps = _getTotalSteps(isAdmin);
    final isLastStep = state.currentStep == totalSteps - 1;
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
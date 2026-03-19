import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/app_switch.dart';
import '../../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../../auth/presentation/bloc/auth_state.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';

class MasterTriggerSettingsStep extends StatelessWidget {
  const MasterTriggerSettingsStep({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final isAdminRole = _isAdminRole(context);
        final settings = isAdminRole
            ? UserFormState.masterTriggerSettings
            : UserFormState.masterRoleTriggerSettings;
        final leftSettings = settings
            .where((s) => settings.indexOf(s) % 2 == 0)
            .toList();
        final rightSettings = settings
            .where((s) => settings.indexOf(s) % 2 == 1)
            .toList();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.0),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: leftSettings.map((setting) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _buildSettingRow(context, state, setting),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  children: rightSettings.map((setting) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _buildSettingRow(context, state, setting),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingRow(
    BuildContext context,
    UserFormState state,
    TriggerSetting setting,
  ) {
    final isEnabled = state.triggerSettings[setting.key] ?? false;
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              _getSvgIconForSetting(setting.key),
              width: 18.w,
              height: 18.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            setting.label,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor(context),
            ),
          ),
        ),
        AppSwitch(
          value: isEnabled,
          onChanged: (value) {
            context.read<UserFormBloc>().add(
              UpdateTriggerSettingEvent(
                settingName: setting.key,
                isEnabled: value,
              ),
            );
          },
        ),
      ],
    );
  }

  bool _isAdminRole(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.role == 'Admin';
    }
    return false;
  }

  String _getSvgIconForSetting(String key) {
    switch (key) {
      case 'addMaster':
        return AppImages.addMasterIcon;
      case 'freshLimitSL':
        return AppImages.freshLimitSlIcon;
      case 'symbolWiseSLLimit':
        return AppImages.symbolWiseIcon;
      case 'changePasswordFirstTime':
        return AppImages.changePasswordIcon;
      case 'fifteenDays':
        return AppImages.fifteenDaysIcon;
      case 'autoSquareOff':
        return AppImages.autoSquareOffIcon;
      case 'canTradeForClient':
        return AppImages.canTradeForClientIcon;
      case 'allowChatWithSuperAdmin':
        return AppImages.messageIcon;
      default:
        return AppImages.statusIcon;
    }
  }
}
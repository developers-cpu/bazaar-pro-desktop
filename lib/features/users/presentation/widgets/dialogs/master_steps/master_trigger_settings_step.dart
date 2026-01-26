import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_switch.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';


class MasterTriggerSettingsStep extends StatelessWidget {
  const MasterTriggerSettingsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final settings = UserFormState.masterTriggerSettings;

        final leftSettings = settings
            .where((s) => settings.indexOf(s) % 2 == 0)
            .toList();
        final rightSettings = settings
            .where((s) => settings.indexOf(s) % 2 == 1)
            .toList();

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  children: leftSettings.map((setting) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildSettingRow(context, state, setting),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 24.w),
              // Right column
              Expanded(
                child: Column(
                  children: rightSettings.map((setting) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
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
        // Icon
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Icon(
            _getIconForSetting(setting.key),
            size: 16.sp,
            color: AppColors.primaryBlue,
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

  IconData _getIconForSetting(String key) {
    switch (key) {
      case 'addMaster':
        return Icons.person_add;
      case 'addClient':
        return Icons.group_add;
      case 'editPermission':
        return Icons.edit;
      case 'fifteenDays':
        return Icons.calendar_today;
      case 'freshLimitSL':
        return Icons.trending_up;
      case 'autoSquareOff':
        return Icons.timer;
      case 'tradeLock':
        return Icons.lock;
      case 'closeMode':
        return Icons.close;
      case 'symbolWiseSLLimit':
        return Icons.percent;
      case 'canTradeForClient':
        return Icons.swap_horiz;
      case 'changePasswordFirstTime':
        return Icons.password;
      case 'lockUser':
        return Icons.person_off;
      case 'status':
        return Icons.toggle_on;
      default:
        return Icons.settings;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
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

  String _getSvgIconForSetting(String key) {
    switch (key) {
      case 'addMaster':
        return AppImages.addMasterIcon;
      case 'addClient':
        return AppImages.addClientIcon;
      case 'editPermission':
        return AppImages.editPermissionIcon;
      case 'fifteenDays':
        return AppImages.fifteenDaysIcon;
      case 'freshLimitSL':
        return AppImages.freshLimitSlIcon;
      case 'autoSquareOff':
        return AppImages.autoSquareOffIcon;
      case 'tradeLock':
        return AppImages.tradeLockIcon;
      case 'closeMode':
        return AppImages.closeModeIcon;
      case 'symbolWiseSLLimit':
        return AppImages.symbolWiseIcon;
      case 'canTradeForClient':
        return AppImages.canTradeForClientIcon;
      case 'changePasswordFirstTime':
        return AppImages.changePasswordIcon;
      case 'lockUser':
        return AppImages.lockUserIcon;
      case 'status':
        return AppImages.statusIcon;
      default:
        return AppImages.statusIcon;
    }
  }
}
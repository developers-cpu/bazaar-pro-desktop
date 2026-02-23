import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/app_switch.dart';
import '../../../../../core/widget/common_dilog_box.dart';
class UpdateAccessDialog extends StatefulWidget {
  final String userId;
  final String userName;
  final Map<String, bool> currentSettings;
  final Function(Map<String, bool> updatedSettings) onUpdate;
  const UpdateAccessDialog({
    super.key,
    required this.userId,
    required this.userName,
    required this.currentSettings,
    required this.onUpdate,
  });
  static void show({
    required BuildContext context,
    required String userId,
    required String userName,
    required Map<String, bool> currentSettings,
    required Function(Map<String, bool> updatedSettings) onUpdate,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => UpdateAccessDialog(
        userId: userId,
        userName: userName,
        currentSettings: currentSettings,
        onUpdate: onUpdate,
      ),
    );
  }
  @override
  State<UpdateAccessDialog> createState() => _UpdateAccessDialogState();
}
class _UpdateAccessDialogState extends State<UpdateAccessDialog> {
  late Map<String, bool> _settings;
  @override
  void initState() {
    super.initState();
    _settings = Map.from(widget.currentSettings);
  }
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Update Access (${widget.userName})',
      width: 500.w,
      showButtons: false,
      onSave: () {
        widget.onUpdate(_settings);
      },
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _settings.keys.map((key) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildSettingRow(key),
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget _buildSettingRow(String key) {
    final label = _getLabel(key);
    final iconPath = _getIconPath(key);
    final isEnabled = _settings[key] ?? false;
    return Row(
      children: [
        if (iconPath != null)
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(6.w),
            child: SvgPicture.asset(iconPath),
          ),
        if (iconPath == null) Container(width: 32.w, height: 32.h),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(context),
            ),
          ),
        ),
        AppSwitch(
          value: isEnabled,
          onChanged: (value) {
            setState(() {
              _settings[key] = value;
            });
          },
        ),
      ],
    );
  }
  String _getLabel(String key) {
    switch (key) {
      case 'bet':
        return 'BET';
      case 'closeOnly':
        return 'Close Only';
      case 'viewOnly':
        return 'View Only';
      case 'status':
        return 'Status';
      case 'allowChat':
        return 'Allow Chat with Super admin';
      case 'positionCut15Days':
        return 'Position Cut 15 Days';
      case 'freshLimitSL':
        return 'Fresh Limit SL';
      case 'lockUser':
        return 'Lock user';
      default:
        return key;
    }
  }
  String? _getIconPath(String key) {
    switch (key) {
      case 'bet':
        return AppImages.tradeLockIcon;
      case 'closeOnly':
        return AppImages.closeModeIcon;
      case 'viewOnly':
        return AppImages.canTradeForClientIcon;
      case 'status':
        return AppImages.statusIcon;
      case 'allowChat':
        return AppImages.messageIcon;
      case 'positionCut15Days':
        return AppImages.fifteenDaysIcon;
      case 'freshLimitSL':
        return AppImages.freshLimitSlIcon;
      case 'lockUser':
        return AppImages.lockUserIcon;
      default:
        return AppImages.statusIcon;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';

/// Leverage Update Dialog - Opens when clicking on LVRJ column
class LeverageUpdateDialog extends StatefulWidget {
  final String userId;
  final String userName;
  final String currentLeverage;
  final Function(String newLeverage)? onUpdate;

  const LeverageUpdateDialog({
    super.key,
    required this.userId,
    required this.userName,
    required this.currentLeverage,
    this.onUpdate,
  });

  /// Show the leverage update dialog
  static void show({
    required BuildContext context,
    required String userId,
    required String userName,
    required String currentLeverage,
    Function(String newLeverage)? onUpdate,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => LeverageUpdateDialog(
        userId: userId,
        userName: userName,
        currentLeverage: currentLeverage,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<LeverageUpdateDialog> createState() => _LeverageUpdateDialogState();
}

class _LeverageUpdateDialogState extends State<LeverageUpdateDialog> {
  String? _selectedLeverage;

  final List<String> _leverageOptions = [
    '1:1',
    '1:2',
    '1:5',
    '1:10',
    '1:20',
    '1:50',
    '1:100',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLeverage = widget.currentLeverage;
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Update Leverage',
      width: 400.w,
      showButtons: true,
      cancelText: 'Cancel',
      saveText: 'Update',
      onSave: () {
        if (_selectedLeverage != null) {
          widget.onUpdate?.call(_selectedLeverage!);
        }
      },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // User Info
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.primaryBlue,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Text(
                      'Current: ${widget.currentLeverage}',
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // Leverage Selection
          Text(
            'Select Leverage',
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedLeverage,
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Select Leverage',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                items: _leverageOptions.map((leverage) {
                  return DropdownMenuItem(
                    value: leverage,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        leverage,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor(context),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLeverage = value;
                  });
                },
                icon: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';

class LeverageUpdateDialog {
  static void show({
    required BuildContext context,
    required String userId,
    required String userName,
    required String currentLeverage,
    Function(String newLeverage)? onUpdate,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Update Leverage ($userName)',
      width: 400.w,
      showButtons: false,
      contentBuilder: (context, onClose) => _LeverageUpdateContent(
        userId: userId,
        userName: userName,
        currentLeverage: currentLeverage,
        onUpdate: onUpdate,
        onClose: onClose,
      ),
    );
  }
}

class _LeverageUpdateContent extends StatefulWidget {
  final String userId;
  final String userName;
  final String currentLeverage;
  final Function(String newLeverage)? onUpdate;
  final VoidCallback onClose;
  const _LeverageUpdateContent({
    Key? key,
    required this.userId,
    required this.userName,
    required this.currentLeverage,
    required this.onClose,
    this.onUpdate,
  }) : super(key: key);
  @override
  State<_LeverageUpdateContent> createState() => _LeverageUpdateContentState();
}

class _LeverageUpdateContentState extends State<_LeverageUpdateContent> {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDropdown(
              type: AppDropdownType.simple,
              hintText: 'Leverage',
              value: _selectedLeverage,
              items: _leverageOptions,
              width: availableWidth,
              height: 35.h,
              isDarkMode: isDarkMode,
              borderColor: AppColors.primaryBlue,
              textColor: AppColors.textColor(context),
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _selectedLeverage = value;
                  });
                }
              },
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 32.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedLeverage != null) {
                    widget.onUpdate?.call(_selectedLeverage!);
                  }
                  widget.onClose();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Update',
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
import 'square_off_dialog.dart';
import 'roll_over_dialog.dart';
class SelectUserDialog extends StatefulWidget {
  final String actionType;
  const SelectUserDialog({Key? key, required this.actionType})
    : super(key: key);
  static void show({
    required BuildContext context,
    required String actionType,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => SelectUserDialog(actionType: actionType),
    );
  }
  @override
  State<SelectUserDialog> createState() => _SelectUserDialogState();
}
class _SelectUserDialogState extends State<SelectUserDialog> {
  String _selectedUser = 'Client 1';
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Select User',
      width: 400.w,
      showButtons: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      content: AppDropdown(
        type: AppDropdownType.search,
        value: _selectedUser,
        hintText: 'Select User',
        items: const [
          'Client 1',
          'Client 2',
          'Client 3',
          'Client 4',
          'Client 5',
        ],
        borderColor: const Color(0xFF1D4A66),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              _selectedUser = val;
            });
            Navigator.pop(context);
            if (widget.actionType == 'SquareOff') {
              SquareOffDialog.show(context: context);
            } else if (widget.actionType == 'RollOver') {
              RollOverDialog.show(context: context);
            }
          }
        },
      ),
    );
  }
}

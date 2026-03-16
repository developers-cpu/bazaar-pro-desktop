import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
import 'square_off_dialog.dart';
import 'roll_over_dialog.dart';
class SelectUserDialog {
  static void show({
    required BuildContext context,
    required String actionType,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Select User',
      width: 400.w,
      showButtons: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      contentBuilder: (context, onClose) => _SelectUserContent(
        actionType: actionType,
        onClose: onClose,
      ),
    );
  }
}
class _SelectUserContent extends StatefulWidget {
  final String actionType;
  final VoidCallback onClose;
  const _SelectUserContent({
    Key? key,
    required this.actionType,
    required this.onClose,
  }) : super(key: key);
  @override
  State<_SelectUserContent> createState() => _SelectUserContentState();
}
class _SelectUserContentState extends State<_SelectUserContent> {
  String _selectedUser = 'Client 1';
  @override
  Widget build(BuildContext context) {
    return AppDropdown(
      type: AppDropdownType.search,
      value: _selectedUser,
      hintText: 'Username',
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
          widget.onClose();
          if (widget.actionType == 'SquareOff') {
            SquareOffDialog.show(context: context);
          } else if (widget.actionType == 'RollOver') {
            RollOverDialog.show(context: context);
          }
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/common_dilog_box.dart';

class AddEditServerDialog extends StatefulWidget {
  final String title;
  final String buttonText;
  final String initialServerName;
  final Function(String serverName, String logoPath) onSubmit;
  const AddEditServerDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onSubmit,
    this.initialServerName = '',
  });
  @override
  State<AddEditServerDialog> createState() => _AddEditServerDialogState();
}

class _AddEditServerDialogState extends State<AddEditServerDialog> {
  late TextEditingController _serverNameCtrl;
  final TextEditingController _logoFileCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    _serverNameCtrl = TextEditingController(text: widget.initialServerName);
    _logoFileCtrl.text = 'Browse File (Server Logo)';
  }

  @override
  void dispose() {
    _serverNameCtrl.dispose();
    _logoFileCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: widget.title,
      width: 400.w,
      showButtons: false,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: _serverNameCtrl,
                    hintText: 'Server Name',
                    height: 35.h,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomInputField(
                        controller: _logoFileCtrl,
                        hintText: 'Browse File (Server Logo)',
                        height: 35.h,
                      ),
                      Positioned.fill(child: InkWell(onTap: () {})),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Center(
              child: CustomActionButton(
                text: widget.buttonText,
                onPressed: () {
                  widget.onSubmit(
                    _serverNameCtrl.text.trim(),
                    _logoFileCtrl.text,
                  );
                  Navigator.of(context).pop();
                },
                width: 120.w,
                height: 36.h,
                borderRadius: 6.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

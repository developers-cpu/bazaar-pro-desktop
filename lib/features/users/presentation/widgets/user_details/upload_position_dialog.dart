import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:bazarpro/core/widget/custom_action_button.dart';
import 'package:bazarpro/core/widget/app_file_picker.dart';

class UploadPositionDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Upload Position',
      width: 500.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(20.w),
      contentBuilder: (context, onClose) {
        return _UploadPositionContent(onClose: onClose);
      },
    );
  }
}

class _UploadPositionContent extends StatefulWidget {
  final VoidCallback onClose;
  const _UploadPositionContent({Key? key, required this.onClose}) : super(key: key);
  @override
  State<_UploadPositionContent> createState() => _UploadPositionContentState();
}

class _UploadPositionContentState extends State<_UploadPositionContent> {
  final GlobalKey<AppFilePickerState> _filePickerKey =
      GlobalKey<AppFilePickerState>();

  void _onUpload() {
    final pickedFile = _filePickerKey.currentState?.pickedFile;
    if (pickedFile != null) {
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppFilePicker(
            key: _filePickerKey,
            hintText: 'CHOOSE FILE PATH',
            height: 35.h,
          ),
        ),
        SizedBox(width: 15.w),
        CustomActionButton(
          text: 'Upload',
          onPressed: _onUpload,
          width: 100.w,
          height: 35.h,
          borderRadius: 8.r,
        ),
      ],
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/app_file_picker.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';

class ImportDateSettingsDialog {
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Import Data',
      width: 500.w,
      showButtons: false,
      contentBuilder: (context, onClose) =>
          _ImportDateSettingsContent(onClose: onClose),
    );
  }
}

class _ImportDateSettingsContent extends StatefulWidget {
  final VoidCallback onClose;
  const _ImportDateSettingsContent({Key? key, required this.onClose})
    : super(key: key);

  @override
  State<_ImportDateSettingsContent> createState() =>
      _ImportDateSettingsContentState();
}

class _ImportDateSettingsContentState
    extends State<_ImportDateSettingsContent> {
  PlatformFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImportSection(),
        SizedBox(height: 20.h),
        _buildUpdateButton(context),
      ],
    );
  }

  Widget _buildImportSection() {
    return Row(
      children: [
        Expanded(
          child: AppFilePicker(
            hintText: 'Browse File',
            allowedExtensions: ['csv', 'xlsx', 'xls'],
            height: 36.h,
            onFilePicked: (file) {
              setState(() => _pickedFile = file);
            },
          ),
        ),
        SizedBox(width: 12.w),
        CustomActionButton(
          text: 'Import',
          onPressed: _pickedFile != null ? () {} : () {},
          width: 100.w,
          height: 36.h,
          borderRadius: 8.r,
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Center(
      child: CustomActionButton(
        text: 'Update',
        onPressed: widget.onClose,
        width: 100.w,
        height: 36.h,
        borderRadius: 8.r,
      ),
    );
  }
}
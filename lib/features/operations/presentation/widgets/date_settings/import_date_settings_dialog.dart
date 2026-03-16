import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';

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

class _ImportDateSettingsContent extends StatelessWidget {
  final VoidCallback onClose;
  const _ImportDateSettingsContent({Key? key, required this.onClose})
    : super(key: key);
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
          child: CustomInputField(
            hintText: 'Browse File',
            width: double.infinity,
            height: 36.h,
          ),
        ),
        SizedBox(width: 12.w),
        CustomActionButton(
          text: 'Import',
          onPressed: () {},
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
        onPressed: onClose,
        width: 100.w,
        height: 36.h,
        borderRadius: 8.r,
      ),
    );
  }
}

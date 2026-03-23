import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bazarpro/core/widget/common_dilog_box.dart';
import 'package:bazarpro/core/widget/custom_action_button.dart';
import 'package:bazarpro/core/widget/app_file_picker.dart';
import '../../../bloc/settlement_progress/settlement_progress_bloc.dart';
import '../../../bloc/settlement_progress/settlement_progress_event.dart';

class ImportFileDialog {
  static void show(BuildContext context, {SettlementProgressBloc? bloc}) {
    CommonDialog.show(
      context: context,
      title: 'Import File',
      width: 500.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(20.w),
      contentBuilder: (context, onClose) {
        final content = _ImportFileContent(onClose: onClose);
        if (bloc != null) {
          return BlocProvider.value(value: bloc, child: content);
        }
        return content;
      },
    );
  }
}

class _ImportFileContent extends StatefulWidget {
  final VoidCallback onClose;
  const _ImportFileContent({Key? key, required this.onClose}) : super(key: key);
  @override
  State<_ImportFileContent> createState() => _ImportFileContentState();
}

class _ImportFileContentState extends State<_ImportFileContent> {
  final GlobalKey<AppFilePickerState> _filePickerKey =
      GlobalKey<AppFilePickerState>();

  void _onImport() {
    final pickedFile = _filePickerKey.currentState?.pickedFile;
    if (pickedFile != null) {
      context.read<SettlementProgressBloc>().add(
        ImportFileEvent(pickedFile.name),
      );
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
            hintText: 'CHOOSE BHAV COPY PATH',
            height: 35.h,
          ),
        ),
        SizedBox(width: 15.w),
        CustomActionButton(
          text: 'Import',
          onPressed: _onImport,
          width: 100.w,
          height: 35.h,
          borderRadius: 8.r,
        ),
      ],
    );
  }
}

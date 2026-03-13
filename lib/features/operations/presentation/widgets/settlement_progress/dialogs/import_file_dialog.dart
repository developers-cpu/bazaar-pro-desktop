import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
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

  const _ImportFileContent({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ImportFileContent> createState() => _ImportFileContentState();
}

class _ImportFileContentState extends State<_ImportFileContent> {
  final _fileController = TextEditingController();

  @override
  void dispose() {
    _fileController.dispose();
    super.dispose();
  }

  void _onImport() {
    if (_fileController.text.isNotEmpty) {
      context.read<SettlementProgressBloc>().add(
        ImportFileEvent(_fileController.text),
      );
      widget.onClose();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a file or enter a path')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomInputField(
            controller: _fileController,
            hintText: 'Choose File',
            height: 35.h,
          ),
        ),
        SizedBox(width: 15.w),
        CustomActionButton(
          text: 'Import',
          onPressed: _onImport,
          width: 100.w,
          height: 35.h,
        ),
      ],
    );
  }
}

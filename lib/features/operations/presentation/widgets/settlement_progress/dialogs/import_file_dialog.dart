import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../bloc/settlement_progress/settlement_progress_bloc.dart';
import '../../../bloc/settlement_progress/settlement_progress_event.dart';

class ImportFileDialog extends StatefulWidget {
  const ImportFileDialog({super.key});

  @override
  State<ImportFileDialog> createState() => _ImportFileDialogState();
}

class _ImportFileDialogState extends State<ImportFileDialog> {
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
      Navigator.of(context).pop(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a file or enter a path')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Import File',
      width: 500.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(20.w),
      content: Row(
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
      ),
    );
  }
}

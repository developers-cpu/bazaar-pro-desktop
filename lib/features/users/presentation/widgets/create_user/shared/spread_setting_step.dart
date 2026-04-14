import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';

class SpreadSettingStep extends StatelessWidget {
  const SpreadSettingStep({super.key});

  static const List<String> exchanges = [
    'NSE',
    'MCX',
    'CE/PE',
    'GIFT',
    'OTHERS',
    'COMEX FUTURE',
    'COMEX SPOT',
    'CRYPTO',
    'FOREX',
    'USSTOCK',
  ];

  static const List<ViewTableColumn> _columns = [
    ViewTableColumn(
      id: 'exchange',
      label: 'EXCHANGE',
      width: 120,
      sortable: false,
    ),
    ViewTableColumn(
      id: 'fileAttachment',
      label: 'FILE ATTACHMENT',
      width: 200,
      sortable: false,
    ),
    ViewTableColumn(
      id: 'action',
      label: 'ACTION',
      width: 100,
      sortable: false,
    ),
  ];

  Future<void> _pickFile(BuildContext context, String exchange) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      if (context.mounted) {
        context.read<UserFormBloc>().add(
              UpdateSpreadFileEvent(
                exchange: exchange,
                filePath: result.files.single.name,
              ),
            );
      }
    }
  }

  Widget _buildCell(BuildContext context, String exchange, ViewTableColumn column, UserFormState state) {
    switch (column.id) {
      case 'exchange':
        return Center(
          child: Text(
            exchange,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(context),
            ),
          ),
        );
      case 'fileAttachment':
        final fileName = state.spreadSettingFiles[exchange] ?? '';
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
          child: GestureDetector(
            onTap: () => _pickFile(context, exchange),
            child: AbsorbPointer(
              child: CustomInputField(
                controller: TextEditingController(text: fileName),
                hintText: 'Browse File',
                height: 32.h,
                width: double.infinity,
              ),
            ),
          ),
        );
      case 'action':
        return Center(
          child: CustomActionButton(
            text: 'Import',
            height: 28.h,
            width: 80.w,
            borderRadius: 8.r,
            onPressed: () {
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Importing spread for $exchange...')),
              );
            },
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return Column(
          children: [
            ViewDataTable<String>(
              columns: _columns,
              data: exchanges,
              idExtractor: (ex) => ex,
              comparatorBuilder: (ex, _) => ex,
              cellBuilder: (ex, col) => _buildCell(context, ex, col, state),
              autoFit: true,
              shrinkWrap: true,
              rowHeight: 48.h,
            ),
            SizedBox(height: 20.h),
            Center(
              child: CustomActionButton(
                text: 'Save',
                height: 35.h,
                width: 200.w,
                borderRadius: 8.r,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Spread settings saved successfully')),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_file_picker.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../bloc/group/group_bloc.dart';

class ImportGroupDataDialog {
  static void show(BuildContext context, {GroupBloc? bloc}) {
    CommonDialog.show(
      context: context,
      title: 'Import Group Data',
      width: 500.w,
      showButtons: false,
      contentBuilder: (context, onClose) {
        final content = _ImportGroupDataContent(onClose: onClose);
        if (bloc != null) {
          return BlocProvider.value(value: bloc, child: content);
        }
        return content;
      },
    );
  }
}

class _ImportGroupDataContent extends StatefulWidget {
  final VoidCallback onClose;
  const _ImportGroupDataContent({Key? key, required this.onClose})
    : super(key: key);

  @override
  State<_ImportGroupDataContent> createState() =>
      _ImportGroupDataContentState();
}

class _ImportGroupDataContentState extends State<_ImportGroupDataContent> {
  PlatformFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInstructions(),
        SizedBox(height: 15.h),
        _buildImportSection(),
        SizedBox(height: 20.h),
        _buildUpdateButton(context),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please make sure required fields given below before creating group - कृपया समूह बनाने से पहले नीचे दिए गए आवश्यक फ़ील्ड सुनिश्चित करें',
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 10.h),
        _buildInstructionItem('1. MCX, CE/PE: Lot Max, BreakUp Lot'),
        _buildInstructionItem(
          '2. NSE, GIFT, OTHERS, CDS, COMEX, USSTOCK, CRYPTO, FOREX: Quantity Max, Breakup Quantity',
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
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

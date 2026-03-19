import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_input_field.dart';

class PasswordDialog {
  static void show(
    BuildContext context, {
    required ValueChanged<bool> onSuccess,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Enter Password',
      width: 400.w,
      showButtons: false,
      contentBuilder: (context, onClose) =>
          _PasswordContent(onClose: onClose, onSuccess: onSuccess),
    );
  }
}

class _PasswordContent extends StatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<bool> onSuccess;
  const _PasswordContent({
    Key? key,
    required this.onClose,
    required this.onSuccess,
  }) : super(key: key);
  @override
  State<_PasswordContent> createState() => _PasswordContentState();
}

class _PasswordContentState extends State<_PasswordContent> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;
  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_passwordCtrl.text.isEmpty) {
      setState(() => _error = 'Password cannot be empty');
      return;
    }
    if (_passwordCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    widget.onSuccess(true);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12.h),
        CustomInputField(
          controller: _passwordCtrl,
          hintText: 'Password',
          obscureText: _obscurePassword,
          width: double.infinity,
          height: 34.h,
          showErrorBorder: false,
          suffixIcon: _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixIconPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        SizedBox(height: 12.h),
        CustomInputField(
          controller: _confirmCtrl,
          hintText: 'Confirm Password',
          obscureText: _obscureConfirm,
          width: double.infinity,
          height: 34.h,
          showErrorBorder: false,
          suffixIcon: _obscureConfirm
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixIconPressed: () {
            setState(() => _obscureConfirm = !_obscureConfirm);
          },
        ),
        if (_error != null) ...[
          SizedBox(height: 8.h),
          Text(
            _error!,
            style: GoogleFonts.openSans(fontSize: 11.sp, color: Colors.red),
          ),
        ],
        SizedBox(height: 16.h),
        SizedBox(
          height: 34.h,
          child: ElevatedButton(
            onPressed: _onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
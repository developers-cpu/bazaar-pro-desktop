import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_input_field.dart';

class ChangePasswordDialog extends StatefulWidget {
  final String userId;
  final String userName;
  final Function(String oldPassword, String newPassword) onChangePassword;

  const ChangePasswordDialog({
    super.key,
    required this.userId,
    required this.userName,
    required this.onChangePassword,
  });

  static void show({
    required BuildContext context,
    required String userId,
    required String userName,
    required Function(String oldPassword, String newPassword) onChangePassword,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangePasswordDialog(
        userId: userId,
        userName: userName,
        onChangePassword: onChangePassword,
      ),
    );
  }

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Change Password (${widget.userName})',
      width: 400.w,
      saveText: 'Update',
      cancelText: 'Cancel',
      onSave: _handleSubmit,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInputField(
              controller: _currentPasswordController,
              hintText: 'Current Password',
              obscureText: _obscureCurrent,
              suffixIcon: _obscureCurrent
                  ? Icons.visibility_off
                  : Icons.visibility,
              onSuffixIconPressed: () {
                setState(() {
                  _obscureCurrent = !_obscureCurrent;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter current password';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomInputField(
              controller: _newPasswordController,
              hintText: 'New Password',
              obscureText: _obscureNew,
              suffixIcon: _obscureNew ? Icons.visibility_off : Icons.visibility,
              onSuffixIconPressed: () {
                setState(() {
                  _obscureNew = !_obscureNew;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomInputField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: _obscureConfirm,
              suffixIcon: _obscureConfirm
                  ? Icons.visibility_off
                  : Icons.visibility,
              onSuffixIconPressed: () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onChangePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';

class BrokerFormDialog extends StatefulWidget {
  final VoidCallback? onComplete;

  const BrokerFormDialog({super.key, this.onComplete});

  static void showCreate({
    required BuildContext context,
    VoidCallback? onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (_) => BrokerFormDialog(onComplete: onComplete),
    );
  }

  @override
  State<BrokerFormDialog> createState() => _BrokerFormDialogState();
}

class _BrokerFormDialogState extends State<BrokerFormDialog> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pop(context);
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 580.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomInputField(
                            controller: _nameController,
                            hintText: 'Name',
                            height: 35.h,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomInputField(
                            controller: _passwordController,
                            hintText: 'Password',
                            height: 35.h,
                            obscureText: _obscurePassword,
                            suffixIcon: _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onSuffixIconPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomInputField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            height: 35.h,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onSuffixIconPressed: () {
                              setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: CustomActionButton(
                text: 'Create',
                width: double.infinity,
                height: 35.h,
                borderRadius: 8.r,
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        height: 45.h,
        color: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Create Broker',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, size: 24.sp, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
